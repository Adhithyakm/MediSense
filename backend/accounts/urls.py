
from django.urls import path
from . import views
# 🛑 Change the imported name from ProfileUpdateView to ProfileView 🛑
from .views import RegisterView, ProfileView,CustomLoginView


urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', CustomLoginView.as_view(), name='login'),
    # 🛑 Change the view used in the path to ProfileView 🛑
    path('profile/', ProfileView.as_view(), name='profile'),
    path('update-fcm-token/', views.update_fcm_token, name='update_fcm_token'),
]