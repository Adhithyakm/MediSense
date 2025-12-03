# accounts/views.py

from rest_framework import generics, status
from rest_framework.response import Response
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.authentication import TokenAuthentication
# Assuming these imports are present
from .serializers import RegisterSerializer, ProfileSetupSerializer
from .models import Profile


# Registration view (Must be public)
class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny] # CORRECT

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            self.perform_create(serializer)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            # This is where the 400 error response is sent
            print("Validation errors:", serializer.errors)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# Profile setup/update view (Must be protected)
class ProfileUpdateView(generics.UpdateAPIView):
    serializer_class = ProfileSetupSerializer
    authentication_classes = [TokenAuthentication] # CORRECT
    permission_classes = [IsAuthenticated] # CORRECT

    def get_object(self):
        # 🛑 FINAL VIEW FIX: Use get_or_create to prevent "Profile matching query does not exist."
        profile, created = Profile.objects.get_or_create(user=self.request.user)
        return profile

# You may also have other views like LoginView (ensure it uses AllowAny)
# ...