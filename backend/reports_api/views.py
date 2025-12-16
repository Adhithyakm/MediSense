from rest_framework.decorators import api_view
from rest_framework.response import Response
# Import Q object for potentially more complex queries if needed,
# but LocalBody model is essential.
from .models import LocalBody

# ----------------------------------------------------------------------
# 1. get_districts (Fetches the list of all unique districts)
# ----------------------------------------------------------------------
@api_view(['GET'])
def get_districts(request):
    """
    Returns a unique list of all district names.
    """
    # Use .distinct() to ensure unique district names.
    districts = LocalBody.objects.values_list('district_name', flat=True).distinct()
    return Response({"districts": list(districts)})

# ----------------------------------------------------------------------
# 2. get_body_types (Fetches unique body types based on selected district)
# FIXES: Case-insensitivity for accurate filtering.
# ----------------------------------------------------------------------
@api_view(['GET'])
def get_body_types(request):
    """
    Returns unique body types for a given district.
    """
    district = request.GET.get('district')

    if not district:
        # Handle case where district parameter is missing
        return Response({"body_types": []}, status=400)

    # FIX: Use '__iexact' for case-insensitive matching.
    # This prevents issues where 'Alappuzha' != 'alappuzha'.
    body_types = LocalBody.objects.filter(
        district_name__iexact=district
    ).values_list('local_body_type', flat=True).distinct()

    return Response({"body_types": list(body_types)})

# ----------------------------------------------------------------------
# 3. get_local_bodies (Fetches specific local bodies for a type)
# FIXES: Case-insensitivity on both parameters and adding distinctness.
# ----------------------------------------------------------------------
@api_view(['GET'])
def get_local_bodies(request):
    """
    Returns local bodies for a specific district and body type.
    """
    district = request.GET.get('district')
    body_type = request.GET.get('body_type')

    if not district or not body_type:
        # Handle case where parameters are missing
        return Response({"local_bodies": []}, status=400)

    # FIX 1: Use '__iexact' on both parameters for robust filtering.
    # FIX 2: Added '.distinct()' to ensure unique local body names in the final list.
    names = LocalBody.objects.filter(
        district_name__iexact=district,
        local_body_type__iexact=body_type
    ).values_list('local_body_name', flat=True).distinct()

    return Response({"local_bodies": list(names)})