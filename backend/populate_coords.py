import os
import django
import time
from geopy.geocoders import Nominatim
from geopy.exc import GeocoderTimedOut

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'diesesemonitoring.settings')
django.setup()

from reports_api.models import LocalBody

def get_coordinates():
    # Initialize the geocoder (Nominatim is free)
    geolocator = Nominatim(user_agent="medi_sense_surveillance_project")

    # Fetch all Local Bodies where coordinates are missing
    locations = LocalBody.objects.filter(latitude__isnull=True)

    print(f"--- Starting Geocoding for {locations.count()} locations ---")

    for lb in locations:
        # Create a specific search string for Kerala Panchayats
        search_query = f"{lb.local_body_name}, {lb.district_name}, Kerala, India"

        try:
            print(f"Searching for: {search_query}...")
            location = geolocator.geocode(search_query, timeout=10)

            if location:
                lb.latitude = location.latitude
                lb.longitude = location.longitude
                lb.save()
                print(f"✅ SUCCESS: {lb.local_body_name} set to ({lb.latitude}, {lb.longitude})")
            else:
                print(f"⚠️ NOT FOUND: {lb.local_body_name}. You may need to set this manually.")

            # 🛑 IMPORTANT: Nominatim requires 1 second gap between requests
            time.sleep(1.2)

        except GeocoderTimedOut:
            print(f"❌ TIMEOUT: Skipping {lb.local_body_name} for now.")
            continue
        except Exception as e:
            print(f"❌ ERROR for {lb.local_body_name}: {e}")

    print("--- Geocoding Process Finished ---")

if __name__ == "__main__":
    get_coordinates()