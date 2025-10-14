from django.contrib.auth.models import User
from rest_framework import serializers
from .models import Profile  # Adjust the relative import to your app structure

class RegisterSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(write_only=True)
    mobile_number = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('full_name', 'mobile_number', 'email', 'password')
        extra_kwargs = {'password': {'write_only': True}}

    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("This email is already registered.")
        return value

    def create(self, validated_data):
        full_name = validated_data.pop('full_name')
        mobile_number = validated_data.pop('mobile_number')

        user = User.objects.create_user(
            username=validated_data['email'],
            email=validated_data['email'],
            password=validated_data['password'],
        )
        user.first_name = full_name
        user.save()

        Profile.objects.create(user=user, mobile_number=mobile_number)

        return user
