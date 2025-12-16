from django.db import models

class LocalBody(models.Model):
    district_name = models.CharField(max_length=255)
    local_body_type = models.CharField(max_length=100)   # PANCHAYAT / MUNICIPALITY / CORPORATION
    local_body_name = models.CharField(max_length=255)

    def __str__(self):
        return self.local_body_name
