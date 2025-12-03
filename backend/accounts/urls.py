# accounts/urls.py - FINAL CORRECTED VERSION

from django.urls import path
# 🛑 Change the imported name from ProfileUpdateView to ProfileView 🛑
from .views import RegisterView, ProfileView


urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    # 🛑 Change the view used in the path to ProfileView 🛑
    path('profile/', ProfileView.as_view(), name='profile'),
]