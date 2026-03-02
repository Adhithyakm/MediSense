from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Profile

# ---------------------------------------------------------------------------
# 1. REGISTER SERIALIZER (For Resident Sign Up)
# ---------------------------------------------------------------------------
class RegisterSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(write_only=True)
    mobile_number = serializers.CharField(write_only=True)
    # 🟢 Add fcm_token here so it can be saved during signup
    fcm_token = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = User
        fields = ('full_name', 'mobile_number', 'email', 'password', 'fcm_token')
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
        fcm_token = validated_data.pop('fcm_token', None)

        user = User.objects.create_user(
            username=validated_data['email'],
            email=validated_data['email'],
            password=validated_data['password'],
        )

        user.first_name = full_name
        user.save()

        # Create Profile
        Profile.objects.create(
            user=user,
            full_name=full_name,
            mobile_number=mobile_number,
            fcm_token=fcm_token # 🟢 Save token during signup
        )

        return user


# ---------------------------------------------------------------------------
# 2. PROFILE SERIALIZER (Fixed Read-Only Bug)
# ---------------------------------------------------------------------------
class ProfileSetupSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(source='user.email', read_only=True)
    username = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = Profile
        fields = (
            'full_name',
            'mobile_number',
            'email',
            'username',
            'fcm_token', # 🟢 Added to fields
            'role',
            'date_of_birth',
            'gender',
            'district',
            'local_body_name',
            'local_body_type'
        )

        # 🟢 FIX: Removed 'district' and 'local_body_name' from read_only_fields
        # We keep 'role' as read-only so residents can't make themselves officials.
        read_only_fields = ['role', 'username', 'email']