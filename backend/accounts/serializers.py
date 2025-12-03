# accounts/serializers.py

from django.contrib.auth.models import User
from rest_framework import serializers
from .models import Profile


# 🛑 FINAL REGISTER SERIALIZER (Ensures Profile is created with initial data) 🛑
class RegisterSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(write_only=True)
    mobile_number = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('full_name', 'mobile_number', 'email', 'password')
        extra_kwargs = {
            'password': {'write_only': True},
            'email': {'required': True}
        }

    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("This email is already registered.")
        return value

    def create(self, validated_data):
        full_name = validated_data.pop('full_name')
        mobile_number = validated_data.pop('mobile_number')

        # Create the User
        user = User.objects.create_user(
            username=validated_data['email'],
            email=validated_data['email'],
            password=validated_data['password'],
        )

        # Update User's first_name for general utility
        user.first_name = full_name
        user.save()

        # 🛑 INITIALIZE PROFILE WITH REGISTRATION DATA 🛑
        Profile.objects.create(
            user=user,
            full_name=full_name,
            mobile_number=mobile_number,
        )

        return user


# 🛑 FINAL PROFILE SETUP SERIALIZER (Adds Email for Flutter display) 🛑
class ProfileSetupSerializer(serializers.ModelSerializer):
    # 🛑 ADDED: Fetches email from the linked User model
    email = serializers.EmailField(source='user.email', read_only=True)

    class Meta:
        model = Profile
        # 🛑 ADDED: 'email' to the list of fields returned
        fields = ('full_name', 'date_of_birth', 'gender', 'mobile_number', 'email')