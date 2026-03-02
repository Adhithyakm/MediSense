from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.authentication import TokenAuthentication
from rest_framework.authtoken.models import Token
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.decorators import api_view, permission_classes
from django.core.exceptions import ObjectDoesNotExist # 🟢 Fixed import
from .serializers import RegisterSerializer, ProfileSetupSerializer
from .models import Profile
from reports_api.models import OfficialProfile

# ---------------------------------------------------------------------------
# 1. REGISTER VIEW (With Debugging)
# ---------------------------------------------------------------------------
class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny]

    def create(self, request, *args, **kwargs):
        print(f"--- SIGNUP ATTEMPT: {request.data.get('email')} ---")
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()

            # Create profile and save token if sent
            fcm_token = request.data.get('fcm_token')
            profile, created = Profile.objects.get_or_create(user=user)
            if fcm_token:
                profile.fcm_token = fcm_token
                profile.save()

            token, created = Token.objects.get_or_create(user=user)
            response_data = serializer.data
            response_data['token'] = token.key
            print(f"✅ SIGNUP SUCCESS: {user.username}")
            return Response(response_data, status=status.HTTP_201_CREATED)
        else:
            print(f"❌ SIGNUP FAILED: {serializer.errors}")
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# ---------------------------------------------------------------------------
# 2. CUSTOM LOGIN VIEW (With Debugging)
# ---------------------------------------------------------------------------
class CustomLoginView(ObtainAuthToken):
    def post(self, request, *args, **kwargs):
        print(f"--- LOGIN ATTEMPT: {request.data.get('username')} ---")
        serializer = self.serializer_class(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)

        fcm_token = request.data.get('fcm_token')
        role = 'resident'
        jurisdiction = "Unknown"

        # Check for Official Profile
        try:
            official_profile = OfficialProfile.objects.get(user=user)
            role = 'official'
            if official_profile.assigned_local_body:
                jurisdiction = f"{official_profile.assigned_local_body.local_body_name}"
        except OfficialProfile.DoesNotExist:
            # Check for Resident Profile
            profile, created = Profile.objects.get_or_create(user=user)
            role = 'resident'
            if fcm_token:
                profile.fcm_token = fcm_token
                profile.save()
            if profile.local_body_name:
                jurisdiction = profile.local_body_name

        print(f"✅ LOGIN SUCCESS: {user.username} | Role: {role}")
        return Response({
            'token': token.key,
            'role': role,
            'username': user.username,
            'jurisdiction': jurisdiction
        })

# ---------------------------------------------------------------------------
# 3. STANDALONE FCM UPDATE VIEW
# ---------------------------------------------------------------------------
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_fcm_token(request):
    token = request.data.get('fcm_token')
    print(f"--- FCM UPDATE for {request.user.username}: {token} ---")
    profile, _ = Profile.objects.get_or_create(user=request.user)
    profile.fcm_token = token
    profile.save()
    return Response({"status": "token updated"})


# ---------------------------------------------------------------------------
# 4. PROFILE VIEW (The critical part for saving location)
# ---------------------------------------------------------------------------
class ProfileView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get_object(self):
        profile, created = Profile.objects.get_or_create(user=self.request.user)
        return profile

    def get(self, request):
        profile = self.get_object()
        serializer = ProfileSetupSerializer(profile)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def put(self, request):
        profile = self.get_object()

        # 🟢 DEBUG 1: Show raw data arriving from Flutter
        print(f"\n--- PROFILE UPDATE START ({request.user.username}) ---")
        print(f"RAW DATA FROM FLUTTER: {request.data}")

        # partial=True allows us to update only the fields we send (district, local_body_name)
        serializer = ProfileSetupSerializer(profile, data=request.data, partial=True)

        if serializer.is_valid():
            serializer.save()
            # 🟢 DEBUG 2: Show successful save
            print(f"✅ SUCCESS: Database updated. Current Local Body: {profile.local_body_name}")
            return Response(serializer.data)

        # 🔴 DEBUG 3: Show exactly why Django refused to save the data
        print(f"❌ FAILED: Serializer rejected data. Errors: {serializer.errors}")
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)