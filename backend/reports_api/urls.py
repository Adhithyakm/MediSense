from django.urls import path
from . import views

urlpatterns = [
    path("districts/", views.get_districts),
    path("body-types/", views.get_body_types),
    path("local-bodies/", views.get_local_bodies),
]
