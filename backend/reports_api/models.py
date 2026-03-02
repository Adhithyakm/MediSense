from django.db import models
from django.contrib.auth.models import User
from accounts.models import Profile

class LocalBody(models.Model):
    district_name = models.CharField(max_length=255)
    local_body_type = models.CharField(max_length=100) # PANCHAYAT / MUNICIPALITY
    local_body_name = models.CharField(max_length=255)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    def __str__(self):
        return f"{self.local_body_name} ({self.district_name})"

class AnonymousSymptomReport(models.Model):
    local_body = models.ForeignKey(LocalBody, on_delete=models.CASCADE, db_index=True)

    # AI Results
    predicted_disease = models.CharField(max_length=100)
    confidence_score = models.FloatField(default=0.0)
    symptoms_list = models.TextField(blank=True, null=True) # Technical keys (fever, cough)
    symptoms_extracted_by_nlp = models.TextField(blank=True, null=True)

    # Official Review Data
    description = models.TextField(blank=True, null=True)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    specific_address = models.TextField(blank=True, null=True)

    # 🟢 Internal Link for FCM (Invisible to Official)
    internal_user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name="symptom_reports")
    is_alerted = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)
    model_weights_update = models.JSONField(null=True, blank=True)
class CommunityRisk(models.Model):
    local_body = models.ForeignKey(LocalBody, on_delete=models.CASCADE)
    image = models.ImageField(upload_to='risk_images/')
    risk_type = models.CharField(max_length=100)
    ai_detected_label = models.CharField(max_length=100, blank=True, null=True)

    # Mapping
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    location_description = models.TextField()

    # 🟢 Link the user who reported the risk
    internal_user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name="risk_reports")

    created_at = models.DateTimeField(auto_now_add=True)

class OutbreakAlert(models.Model):
    local_body = models.ForeignKey(LocalBody, on_delete=models.CASCADE)
    district = models.CharField(max_length=100, blank=True, null=True)
    disease = models.CharField(max_length=100)
    case_count = models.IntegerField(default=1)
    status = models.CharField(max_length=20, default="WARNING") # WARNING or CRITICAL

    is_verified = models.BooleanField(default=False)
    is_notified = models.BooleanField(default=False) # 🟢 Tracks if 'Alert All' was clicked
    last_notified_at = models.DateTimeField(null=True, blank=True)

    created_at = models.DateTimeField(auto_now_add=True)
    last_updated = models.DateTimeField(auto_now=True)

class OfficialProfile(models.Model):
    # 🟢 FIX: Change related_name to just "official_profile" (no dots!)
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="official_profile")
    full_name = models.CharField(max_length=255)
    assigned_local_body = models.ForeignKey(LocalBody, on_delete=models.SET_NULL, null=True)
    last_report_check = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return f"{self.full_name} ({self.assigned_local_body})"