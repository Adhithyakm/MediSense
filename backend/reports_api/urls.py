from django.urls import path
from . import views

urlpatterns = [
    path('submit-symptoms/', views.submit_health_report),
    path('submit-risk/', views.submit_risk_report),
    path('get-dashboard/', views.get_official_dashboard),

    # 🟢 MAKE SURE THIS LINE IS PRESENT AND MATCHES YOUR FLUTTER URL
    path('trigger-community-alert/', views.trigger_community_alert),

    path('verify-broadcast/', views.verify_and_broadcast),
    path("districts/", views.get_districts),
    path("body-types/", views.get_body_types),
    path("local-bodies/", views.get_local_bodies),
]