import os
import dj_database_url
from pathlib import Path
import firebase_admin
from firebase_admin import credentials

# 1. BASE DIRECTORY
BASE_DIR = Path(__file__).resolve().parent.parent

# 2. SECURITY
SECRET_KEY = 'django-insecure-your-secret-key-here'
DEBUG = True

# 🟢 UPDATE THIS: Add your laptop IP here every time it changes
ALLOWED_HOSTS = [
    '10.213.213.158',
    ' 192.168.24.71',
    'localhost',
    '  192.168.24.71',
    '0.0.0.0',
    '192.168.20.36',
    '192.168.24.71',
    '192.168.24.71',
    '192.168.24.71',
]

# 3. APPS
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # Third Party Apps
    'rest_framework',
    'rest_framework.authtoken',

    # Your Created Apps
    'accounts',
    'userauth',
    'reports_api',
]

# 4. REST FRAMEWORK (Auth & Permissions)
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework.authentication.TokenAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.AllowAny',
    )
}

# 5. MIDDLEWARE
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

# 🟢 MISSING BLOCK RESTORED: TEMPLATES (Required for Admin)
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

ROOT_URLCONF = 'diesesemonitoring.urls'

WSGI_APPLICATION = 'diesesemonitoring.wsgi.application'

# 6. DATABASE (Neon Tech / PostgreSQL)
DATABASES = {
    'default': dj_database_url.parse(
        'postgresql://neondb_owner:npg_XplWZx4inE7L@ep-divine-tree-adtxgd4q-pooler.c-2.us-east-1.aws.neon.tech/neondb?sslmode=require'
    )
}

# 7. STATIC & MEDIA (For Risk Images)
STATIC_URL = 'static/'

# 🟢 CRITICAL: This is where user photos are saved
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# 8. FIREBASE ADMIN SETUP (For Alerts)
# Ensure your serviceAccountKey.json is in the root backend folder (same folder as manage.py)
try:
    cred_path = os.path.join(BASE_DIR, 'serviceAccountKey.json')
    if os.path.exists(cred_path):
        cred = credentials.Certificate(cred_path)
        if not firebase_admin._apps:
            firebase_admin.initialize_app(cred)
        print("✅ Firebase Admin Initialized Successfully")
    else:
        print("⚠️ Warning: serviceAccountKey.json not found in backend/ folder. FCM Alerts will not work.")
except Exception as e:
    print(f"❌ Firebase Init Error: {e}")

# 9. INTERNATIONALIZATION
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'Asia/Kolkata'
USE_I18N = True
USE_TZ = True

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'