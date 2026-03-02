import os
import pandas as pd
import django

# 1. Setup Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'diesesemonitoring.settings')
django.setup()

from django.contrib.auth.models import User
from reports_api.models import LocalBody, OfficialProfile

def run():
    file_path = "officials_data.csv"
    df = pd.read_csv(file_path, skipinitialspace=True)

    print(f"Starting to create {len(df)} profiles...")

    for index, row in df.iterrows():
        try:
            uname = str(row["username"]).strip()
            pwd = str(row["password"]).strip()
            fname = str(row["full_name"]).strip()
            lb_name = str(row["Local_Body_Name"]).strip()
            lb_type = str(row["Local_Body_Type"]).strip()
            dist = str(row["District_Name"]).strip()

            if uname == "nan": continue

            # 1. Find the LocalBody that already exists in your DB
            local_body = LocalBody.objects.filter(
                local_body_name__iexact=lb_name,
                local_body_type__iexact=lb_type,
                district_name__iexact=dist
            ).first()

            if not local_body:
                print(f"❌ Skipping {uname}: LocalBody {lb_name} not found in DB.")
                continue

            # 2. Create the User (if they don't exist)
            user, user_created = User.objects.get_or_create(username=uname)
            if user_created:
                user.set_password(pwd) # Hashes the password correctly
                user.save()

            # 3. Create the Official Profile linking user to the city
            profile, prof_created = OfficialProfile.objects.get_or_create(
                user=user,
                defaults={'full_name': fname, 'assigned_local_body': local_body}
            )

            if prof_created:
                print(f"✅ Created Profile: {uname} -> {lb_name}")
            else:
                print(f"⏩ User {uname} already has a profile.")

        except Exception as e:
            print(f"❌ Error at row {index}: {e}")

    print("\n--- DONE! All 1,145 Official Profiles are ready. ---")

if __name__ == "__main__":
    run()