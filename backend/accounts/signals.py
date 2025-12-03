# accounts/signals.py

from django.db.models.signals import post_save
from django.contrib.auth import get_user_model
from django.dispatch import receiver
from .models import Profile # Import your Profile model

User = get_user_model()

@receiver(post_save, sender=User)
def create_or_update_user_profile(sender, instance, created, **kwargs):
    """
    Creates a Profile object immediately after a new User is created.
    """
    if created:
        Profile.objects.create(user=instance)