import csv
import os
from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from accounts.models import Profile
from django.conf import settings

class Command(BaseCommand):
    help = 'Import Health Officials from CSV file'

    def handle(self, *args, **kwargs):
        file_name = 'officials_data.csv'
        file_path = os.path.join(settings.BASE_DIR, file_name)

        self.stdout.write(f"📂 Looking for file at: {file_path}")

        if not os.path.exists(file_path):
            self.stdout.write(self.style.ERROR('❌ File NOT found.'))
            return

        try:
            with open(file_path, 'r', encoding='utf-8-sig') as file:
                reader = csv.DictReader(file)

                # Check headers
                headers = reader.fieldnames
                if not headers:
                    print("❌ Error: CSV appears to be empty.")
                    return
                print(f"📋 Columns found: {headers}")

                row_num = 0
                success_count = 0

                for row in reader:
                    row_num += 1

                    # 1. Clean Data (Strip spaces)
                    username = row.get('username', '').strip()
                    password = row.get('password', '').strip()
                    full_name = row.get('full_name', '').strip()
                    mobile = row.get('mobile', '').strip()
                    district = row.get('District_Name', '').strip()
                    lb_name = row.get('Local_Body_Name', '').strip()
                    lb_type = row.get('Local_Body_Type', '').strip()

                    if not username:
                        print(f"⚠️ Row {row_num}: Skipped (No username)")
                        continue

                    # 2. Check if user already exists
                    if User.objects.filter(username=username).exists():
                        # We print a small dot or short msg to show progress without spamming
                        print(f"🔹 Row {row_num}: {username} already exists. Skipping.")
                        continue

                    # 3. Create User
                    try:
                        user = User.objects.create_user(
                            username=username,
                            password=password,
                            email=f"{username}@medisense.gov.in"
                        )

                        # 4. Create Profile
                        Profile.objects.create(
                            user=user,
                            full_name=full_name,
                            mobile_number=mobile,
                            role='official',
                            district=district,
                            local_body_name=lb_name,
                            local_body_type=lb_type
                        )
                        print(f"✅ Row {row_num}: Created {username} ({lb_name})")
                        success_count += 1

                    except Exception as db_err:
                        print(f"❌ Row {row_num}: Failed to create {username}. Error: {db_err}")

            self.stdout.write(self.style.SUCCESS(f'\n🎉 FINISHED! Successfully created {success_count} new accounts.'))

        except Exception as e:
            self.stdout.write(self.style.ERROR(f'❌ Critical Error: {str(e)}'))