# accounts/serializers.py

from django.contrib.auth.models import User
from rest_framework import serializers
from .models import Profile  # Adjust import if needed

# Serializer for registration (name, mobile, email, password)
class RegisterSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(write_only=True)
    mobile_number = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('full_name', 'mobile_number', 'email', 'password')
        extra_kwargs = {
            'password': {'write_only': True},
            'email': {'required': True} # Ensure email is treated as required
        }

    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("This email is already registered.")
        return value

    def create(self, validated_data):
        # 🛑 FINAL SERIALIZER FIX: Pop Profile fields before User creation
        full_name = validated_data.pop('full_name')
        mobile_number = validated_data.pop('mobile_number')

        # Create the User object using email as the username (common practice for email-based login)
        user = User.objects.create_user(
            username=validated_data['email'],
            email=validated_data['email'],
            password=validated_data['password'],
        )

        # Save the full name to the User model's first_name field
        user.first_name = full_name
        user.save()

        # Create the associated Profile object (The signal is no longer strictly necessary but doesn't hurt)
        Profile.objects.create(
            user=user,
            full_name=full_name,
            mobile_number=mobile_number,
        )

        return user


# Serializer for profile setup (after registration)
class ProfileSetupSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        # Note: 'full_name' is also here because the user is expected to update it along with the rest
        fields = ('full_name', 'date_of_birth', 'gender', 'mobile_number')