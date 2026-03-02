

# Register your models here.
from django.contrib import admin
from .models import Profile

@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
    # This shows the columns in the list view so you can see the tokens easily
    list_display = ('user', 'role', 'local_body_name', 'district', 'fcm_token')

    # Allows you to search for a specific user or city
    search_fields = ('user__username', 'local_body_name', 'full_name')

    # Adds filters on the right side
    list_filter = ('role', 'district')