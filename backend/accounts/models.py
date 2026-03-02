# accounts/models.py
"""from django.db import models
from django.contrib.auth.models import User

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    full_name = models.CharField(max_length=150, blank=True, null=True)
    mobile_number = models.CharField(max_length=20, blank=True, null=True)
    date_of_birth = models.DateField(blank=True, null=True)
    gender = models.CharField(max_length=10, blank=True, null=True)

    def __str__(self):
        return self.user.username """


from django.db import models
from django.contrib.auth.models import User

class Profile(models.Model):
    # 🟢 1. Define Roles
    ROLE_CHOICES = [
        ('resident', 'Resident'),
        ('official', 'Health Official'),
    ]

    user = models.OneToOneField(User, on_delete=models.CASCADE)

    # 🟢 2. Shared Fields
    full_name = models.CharField(max_length=150, blank=True, null=True)
    mobile_number = models.CharField(max_length=20, blank=True, null=True)

    # 🟢 3. FCM TOKEN (Add this line)
    # This stores the random ID from the phone for Firebase Alerts
    fcm_token = models.CharField(max_length=255, blank=True, null=True)

    # 🟢 4. The Role Switch
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='resident')

    # 🟢 5. Resident Specific Fields
    date_of_birth = models.DateField(blank=True, null=True)
    gender = models.CharField(max_length=10, blank=True, null=True)

    # 🟢 6. Jurisdiction (Used for both Roles)
    # Residents: Home location for receiving local alerts
    # Officials: Assigned area for managing reports
    district = models.CharField(max_length=100, blank=True, null=True)
    local_body_name = models.CharField(max_length=100, blank=True, null=True)
    local_body_type = models.CharField(max_length=50, blank=True, null=True)

    def __str__(self):
        return f"{self.user.username} - {self.role}"