import joblib
import os
import numpy as np
import pandas as pd
from django.conf import settings
from django.utils import timezone
from datetime import timedelta
from django.db.models import Count
from django.db.models.functions import Lower, Trim
from rest_framework.decorators import api_view, parser_classes, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser

# AI & Firebase
import tensorflow as tf
from tensorflow.keras.applications.mobilenet_v2 import MobileNetV2, preprocess_input, decode_predictions
from tensorflow.keras.preprocessing import image as keras_image
import firebase_admin
from firebase_admin import messaging

from .models import LocalBody, AnonymousSymptomReport, OutbreakAlert, CommunityRisk, OfficialProfile
from accounts.models import Profile

# ----------------------------------------------------------------------
# AI MODEL LOADING
# ----------------------------------------------------------------------
ML_DIR = os.path.join(settings.BASE_DIR, 'mlmodel')



try:
    vision_model = MobileNetV2(weights='imagenet')
except Exception as e:
    print(f"🛑 Vision AI Error: {e}")

# ----------------------------------------------------------------------
# HELPERS
# ----------------------------------------------------------------------

def analyze_image_ai(img_path):
    try:
        img = keras_image.load_img(img_path, target_size=(224, 224))
        x = keras_image.img_to_array(img)
        x = np.expand_dims(x, axis=0)
        x = preprocess_input(x)
        preds = vision_model.predict(x)
        decoded = decode_predictions(preds, top=5)[0]

        # 🟢 ADDED MORE KEYWORDS: 'bird', 'crow', 'wing' for your dead bird photo
        risk_map = {
            'water': ['sewer', 'puddle', 'well', 'drain', 'water', 'pond'],
            'animal': ['rat', 'mouse', 'rodent', 'bird', 'crow', 'feather', 'wing', 'vulture'],
            'waste': ['garbage', 'waste', 'plastic', 'ashcan', 'trash']
        }

        for (_, label, prob) in decoded:
            l = label.lower()
            if prob < 0.15: continue  # Lowered threshold slightly for better detection
            if any(w in l for w in risk_map['water']): return "Stagnant Water (Mosquito Risk)"
            if any(a in l for a in risk_map['animal']): return "Dead Animal / Biological Risk"
            if any(w in l for w in risk_map['waste']): return "Garbage Dump / Sanitary Risk"

        return "Environmental Risk Factor"
    except:
        return "Analysis Failed"

def submit_risk_report(request):
    try:
        body_obj = LocalBody.objects.get(id=request.data.get('local_body_id'))

        # 🟢 FIX: Capture Address, Landmark AND Description from Flutter
        address = request.data.get('location_address', 'Unknown Address')
        # Flutter sends landmark inside the 'description' field usually,
        # but let's be safe and try to catch both
        desc_data = request.data.get('description', '')

        full_location_context = f"GPS: {address}\nDetails: {desc_data}"

        risk = CommunityRisk.objects.create(
            local_body=body_obj,
            image=request.FILES.get('image'),
            risk_type=request.data.get('risk_type'),
            location_description=full_location_context, # 🟢 Store combined string
            latitude=request.data.get('latitude', 0.0),
            longitude=request.data.get('longitude', 0.0),
            internal_user=request.user
        )

        risk.ai_detected_label = analyze_image_ai(risk.image.path)
        risk.save()

        return Response({"status": "Success", "ai_detected": risk.ai_detected_label})
    except Exception as e:
        return Response({"error": str(e)}, status=400)
def extract_symptoms_from_text(description):
    found = []
    text = (description or "").lower()
    for col in feature_columns:
        if col.replace('_', ' ') in text: found.append(col)
    return found

# ----------------------------------------------------------------------
# 1. USER ACTIONS
# ----------------------------------------------------------------------

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_fcm_token(request):
    token = request.data.get('fcm_token')
    profile, _ = Profile.objects.get_or_create(user=request.user)
    profile.fcm_token = token
    profile.save()
    return Response({"status": "token updated"})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def submit_health_report(request):
    # 1. Get the conclusion from Flutter
    prediction = request.data.get('predicted_disease', "Unidentified")

    # 🟢 2. GET THE WEIGHTS (This is what you were missing)
    weights = request.data.get('model_weights_update')

    lb_id = request.data.get('local_body_id')
    description = request.data.get('description', "")

    try:
        body_obj = LocalBody.objects.get(id=lb_id)

        # 🟢 3. SAVE TO DATABASE (Pass the weights here)
        AnonymousSymptomReport.objects.create(
            local_body=body_obj,
            predicted_disease=prediction,
            model_weights_update=weights, # 👈 SAVE THE JSON DATA HERE
            description=description,
            latitude=request.data.get('latitude', 0.0),
            longitude=request.data.get('longitude', 0.0),
            specific_address=request.data.get('specific_address', ""),
            internal_user=request.user,
            confidence_score=1.0
        )

        # 🟢 4. PROOF: Check your terminal
        print(f"✅ Federated Learning: Received weights for {prediction}")

        return Response({"status": "Success", "prediction": prediction})
    except Exception as e:
        print(f"❌ Error: {e}")
        return Response({"error": str(e)}, status=500)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
@parser_classes([MultiPartParser, FormParser])
def submit_risk_report(request):
    try:
        body_obj = LocalBody.objects.get(id=request.data.get('local_body_id'))

        # 🟢 FIX: Read BOTH address and description from Flutter
        address = request.data.get('location_address', '')
        details = request.data.get('description', '') # Landmark + Notes are here

        # Merge them into the model's 'location_description' field
        combined_location = f"GPS: {address}\n{details}"

        risk = CommunityRisk.objects.create(
            local_body=body_obj,
            image=request.FILES.get('image'),
            risk_type=request.data.get('risk_type'),
            location_description=combined_location, # 🟢 Now stores everything!
            latitude=request.data.get('latitude', 0.0),
            longitude=request.data.get('longitude', 0.0),
            internal_user=request.user
        )
        # Run the updated AI analysis
        risk.ai_detected_label = analyze_image_ai(risk.image.path)
        risk.save()

        return Response({"status": "Success", "ai_detected": risk.ai_detected_label})
    except Exception as e:
        return Response({"error": str(e)}, status=400)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_official_dashboard(request):
    try:
        # 1. Get Official Profile
        try:
            profile = request.user.official_profile
        except:
            profile = request.user.officialprofile
        my_body = profile.assigned_local_body

        # 2. Base Query for reports in this specific Panchayat
        reports_qs = AnonymousSymptomReport.objects.filter(local_body=my_body)

        # 🟢 NEW REPORTS COUNT (Since last analysis)
        new_reports_count = AnonymousSymptomReport.objects.filter(
            local_body=my_body,
            created_at__gt=profile.last_report_check
        ).count()

        # 3. CUMULATIVE SYMPTOM COUNT
        total_symptoms = 0
        for r in reports_qs:
            if r.symptoms_list:
                items = [s.strip() for s in r.symptoms_list.split(',') if s.strip()]
                total_symptoms += len(items)
            else:
                total_symptoms += 1

        # 4. Aggregation Logic (The 3-case rule)
        from django.db.models.functions import Lower, Trim
        from django.db.models import Count
        from django.utils import timezone
        from datetime import timedelta

        time_limit = timezone.now() - timedelta(days=30)

        disease_counts = AnonymousSymptomReport.objects.filter(
            local_body=my_body,
            created_at__gte=time_limit
        ).annotate(
            name_clean=Lower(Trim('predicted_disease'))
        ).values('name_clean').annotate(
            total=Count('id')
        ).order_by()

        diseases_to_alert = []
        for d in disease_counts:
            d_name = d['name_clean']
            count = d['total']
            if count >= 3:
                alert_obj, _ = OutbreakAlert.objects.get_or_create(local_body=my_body, disease=d_name)
                alert_obj.case_count = count
                alert_obj.status = "CRITICAL"
                alert_obj.save()
                diseases_to_alert.append(d_name)

        # 5. Fetch Environmental Risks (Photos)
        risks_qs = CommunityRisk.objects.filter(local_body=my_body).order_by('-created_at')
        risks_data = [
            {
                "image": request.build_absolute_uri(r.image.url) if r.image else None,
                "risk_type": r.risk_type,
                "ai_tag": r.ai_detected_label,
                "location": r.location_description
            } for r in risks_qs
        ]

        # 🟢 6. GIS MAP LOGIC: Fetch ALL outbreaks in the entire District
        district_alerts_qs = OutbreakAlert.objects.filter(
            local_body__district_name=my_body.district_name
        )

        map_hotspots = []
        for a in district_alerts_qs:
            map_hotspots.append({
                "disease": a.disease,
                "case_count": a.case_count,
                "place_name": a.local_body.local_body_name,
                "lat": a.local_body.latitude or 10.1632,
                "lng": a.local_body.longitude or 76.6413
            })

        # 🟢 7. LOCAL PRIORITY ALERTS (Fixed position)
        local_priority_qs = OutbreakAlert.objects.filter(local_body=my_body)

        return Response({
            "jurisdiction": f"{my_body.local_body_name}",
            "district": my_body.district_name,
            "new_reports_count": new_reports_count,
            "total_symptom_count": total_symptoms,
            "reports": list(reports_qs.order_by('-created_at').values('id', 'predicted_disease', 'description', 'specific_address', 'symptoms_list', 'created_at')),
            "risks": risks_data,
            "diseases_to_alert": diseases_to_alert,
            "priority_alerts": list(local_priority_qs.values('id', 'disease', 'case_count', 'status', 'is_notified', 'is_verified')),
            "district_map_hotspots": map_hotspots
        })

    except Exception as e:
        import traceback
        print(traceback.format_exc())
        return Response({"error": str(e)}, status=400)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def trigger_community_alert(request):
    """Broadcasts notification to ALL residents in the Panchayat."""
    disease = request.data.get('disease', '').lower().strip()
    official_body = request.user.official_profile.assigned_local_body

    # Target Profiles by Location Name
    residents = Profile.objects.filter(local_body_name__iexact=official_body.local_body_name)
    tokens = list(residents.values_list('fcm_token', flat=True).distinct())
    valid_tokens = [t for t in tokens if t]

    if valid_tokens:
        risk = CommunityRisk.objects.filter(local_body=official_body, created_at__gte=timezone.now()-timedelta(hours=48)).first()
        evidence = f" AI verified a {risk.ai_detected_label} nearby." if risk else ""

        message = messaging.MulticastMessage(
            notification=messaging.Notification(
                title=f"🚨 Health Alert: {official_body.local_body_name}",
                body=f"An increase in {disease.upper()} cases was detected.{evidence} Please stay safe!",
            ),
            tokens=valid_tokens,
            android=messaging.AndroidConfig(priority='high')
        )

        messaging.send_each_for_multicast(message)

        # Mark as notified so button disappears
        OutbreakAlert.objects.filter(local_body=official_body, disease=disease).update(is_notified=True)

        return Response({"message": f"Broadcast sent to {len(valid_tokens)} residents."})

    return Response({"error": "No registered residents found to alert."}, status=404)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def verify_and_broadcast(request):
    alert_id = request.data.get('alert_id')
    try:
        alert = OutbreakAlert.objects.get(id=alert_id)
        alert.is_verified = True
        alert.save()
        return Response({"message": "Verified."})
    except: return Response({"message": "Cluster verified."})

# ----------------------------------------------------------------------
# 3. LOCATION HELPERS
# ----------------------------------------------------------------------

@api_view(['GET'])
@permission_classes([AllowAny])
def get_districts(request):
    districts = LocalBody.objects.values_list('district_name', flat=True).distinct()
    return Response({"districts": list(districts)})

@api_view(['GET'])
@permission_classes([AllowAny])
def get_body_types(request):
    district = request.GET.get('district')
    types = LocalBody.objects.filter(district_name__iexact=district).values_list('local_body_type', flat=True).distinct()
    return Response({"body_types": list(types)})

@api_view(['GET'])
@permission_classes([AllowAny])
def get_local_bodies(request):
    district = request.GET.get('district')
    b_type = request.GET.get('body_type')
    bodies = LocalBody.objects.filter(district_name__iexact=district, local_body_type__iexact=b_type).values('id', 'local_body_name')
    return Response({"local_bodies": list(bodies)})
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def clear_report_count(request):
    """Updates the last_report_check timestamp to 'now' so the counter resets."""
    try:
        try:
            profile = request.user.official_profile
        except:
            profile = request.user.officialprofile

        profile.last_report_check = timezone.now()
        profile.save()
        return Response({"status": "success", "message": "Counter reset to zero"})
    except Exception as e:
        return Response({"error": str(e)}, status=400)