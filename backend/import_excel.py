import os
import pandas as pd
import django

# Setup Django Environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'diesesemonitoring.settings')
django.setup()

from django.contrib.auth.models import User
from reports_api.models import LocalBody, OfficialProfile

def run_import():
    file_path = "officials_data.csv"

    if not os.path.exists(file_path):
        print(f"Error: {file_path} not found.")
        return

    print(f"Reading {file_path}...")
    df = pd.read_csv(file_path, skipinitialspace=True)

    success_count = 0
    skipped_count = 0

    for index, row in df.iterrows():
        try:
            uname = str(row["username"]).strip()
            lb_name = str(row["Local_Body_Name"]).strip()
            lb_type = str(row["Local_Body_Type"]).strip()
            dist_name = str(row["District_Name"]).strip()

            if uname == "nan" or lb_name == "nan":
                continue

            # STEP 1: Find or Create the Local Body safely
            # We use filter().first() to avoid the "MultipleObjectsReturned" error
            local_body = LocalBody.objects.filter(
                district_name__iexact=dist_name,
                local_body_type__iexact=lb_type,
                local_body_name__iexact=lb_name
            ).first()

            if not local_body:
                local_body = LocalBody.objects.create(
                    district_name=dist_name,
                    local_body_type=lb_type,
                    local_body_name=lb_name
                )

            # STEP 2: Create User
            if not User.objects.filter(username=uname).exists():
                user = User.objects.create_user(
                    username=uname,
                    password=str(row["password"]).strip()
                )

                # STEP 3: Create Profile
                # We use update_or_create here to avoid profile errors
                OfficialProfile.objects.update_or_create(
                    user=user,
                    defaults={
                        'full_name': str(row["full_name"]).strip(),
                        'assigned_local_body': local_body
                    }
                )
                success_count += 1
                print(f"✅ Imported: {uname} ({lb_name})")
            else:
                skipped_count += 1

        except Exception as e:
            # This prints exactly which user and row is causing trouble
            print(f"❌ Error at row {index} ({row.get('username')}): {e}")

    print(f"\nFinished! Created: {success_count}, Skipped: {skipped_count}")

if __name__ == "__main__":
    run_import()