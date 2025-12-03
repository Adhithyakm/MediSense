# accounts/views.py

from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView # 🛑 APIView is needed for custom GET/PUT methods
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.authentication import TokenAuthentication
from .serializers import RegisterSerializer, ProfileSetupSerializer
from .models import Profile


# Registration view (No changes needed here)
class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            self.perform_create(serializer)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            print("Validation errors:", serializer.errors)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# 🛑 FINAL PROFILE VIEW (Handles both GET and PUT/PATCH) 🛑
class ProfileView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get_object(self):
        # Helper function: ensures a Profile exists for the user, creating one if not.
        profile, created = Profile.objects.get_or_create(user=self.request.user)
        return profile

    # 1. HANDLE GET REQUEST (FETCHING DATA for Flutter Menu/Profile Screen)
    # This fixes the 405 error!
    def get(self, request):
        profile = self.get_object()
        serializer = ProfileSetupSerializer(profile)
        return Response(serializer.data, status=status.HTTP_200_OK)

    # 2. HANDLE PUT REQUEST (UPDATING DATA from Flutter SetupProfileScreen)
    def put(self, request):
        profile = self.get_object()
        serializer = ProfileSetupSerializer(profile, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    # You can add a PATCH method here if you want partial updates

# Remember to ensure your accounts/urls.py points to views.ProfileView.as_view()