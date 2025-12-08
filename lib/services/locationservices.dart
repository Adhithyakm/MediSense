// lib/services/location_service.dart

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// Returns the name of the locality (City/District) or null if it fails
Future<String?> getDetectedLocality() async {
  // 1. Check if location services are enabled on the device
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
    return null;
  }

  // 2. Check and Request Permissions
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      print('Location permission denied.');
      return null;
    }
  }

  try {
    // 3. Get the current position (Latitude and Longitude)
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );

    // 4. Reverse Geocode (Convert coordinates to a human-readable address)
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      // Return the 'locality' (which is often the City or District name)
      return placemarks[0].locality;
    }

    return null; // Geocoding found coordinates but couldn't get a locality name

  } catch (e) {
    print("Error fetching location: $e");
    return null;
  }
}