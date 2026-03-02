from django.contrib import admin
from django.utils.html import format_html # For image previews
from .models import (
    LocalBody,
    AnonymousSymptomReport,
    CommunityRisk,
    OutbreakAlert,
    OfficialProfile
)

@admin.register(LocalBody)
class LocalBodyAdmin(admin.ModelAdmin):
    # What columns to show in the list
    list_display = ('local_body_name', 'local_body_type', 'district_name')
    # Add a search bar for names and districts
    search_fields = ('local_body_name', 'district_name')
    # Add filters on the right side
    list_filter = ('district_name', 'local_body_type')

@admin.register(AnonymousSymptomReport)
class AnonymousReportAdmin(admin.ModelAdmin):
    list_display = ('predicted_disease', 'local_body', 'confidence_score', 'created_at')
    list_filter = ('predicted_disease', 'local_body__district_name', 'created_at')
    # Helpful to see the confidence score clearly
    readonly_fields = ('confidence_score', 'symptoms_extracted_by_nlp')
    search_fields = ('description', 'predicted_disease')

@admin.register(CommunityRisk)
class CommunityRiskAdmin(admin.ModelAdmin):
    list_display = ('risk_type', 'ai_detected_label', 'local_body', 'image_preview', 'created_at')
    list_filter = ('risk_type', 'ai_detected_label', 'created_at')

    # This function shows a small thumbnail of the dead animal/risk in the admin list
    def image_preview(self, obj):
        if obj.image:
            return format_html('<img src="{}" style="width: 50px; height:50px; border-radius: 5px;" />', obj.image.url)
        return "No Image"
    image_preview.short_description = 'Thumbnail'

@admin.register(OutbreakAlert)
class OutbreakAlertAdmin(admin.ModelAdmin):
    list_display = ('disease', 'local_body', 'case_count', 'status', 'is_verified', 'last_updated')
    list_filter = ('status', 'is_verified', 'disease')
    list_editable = ('is_verified',) # Allows you to check the box directly from the list
    search_fields = ('local_body__local_body_name', 'disease')

@admin.register(OfficialProfile)
class OfficialProfileAdmin(admin.ModelAdmin):
    list_display = ('full_name', 'user', 'assigned_local_body')
    search_fields = ('full_name', 'user__username')