import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'review_submit_screen.dart'; // Make sure this file exists

class ReportSymptomsScreen extends StatefulWidget {
  // Receive the city from Home Screen
  final String selectedCity;

  const ReportSymptomsScreen({
    Key? key,
    this.selectedCity = "Unknown Location", // Default fallback
  }) : super(key: key);

  @override
  State<ReportSymptomsScreen> createState() => _ReportSymptomsScreenState();
}

class _ReportSymptomsScreenState extends State<ReportSymptomsScreen> {
  // Controllers for text input
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _otherSymptomController = TextEditingController();

  // State variables
  late String _currentLocation;
  bool _isFetchingLocation = false;

  // Symptom Data
  final List<String> _selectedSymptoms = [];
  final List<String> _availableSymptoms = [
    'Fever',
    'Cough',
    'Headache',
    'Nausea',
    'Skin Rash',
    'Fatigue',
    'Breathing Issues',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize location with the data passed from HomeScreen
    _currentLocation = widget.selectedCity;
  }

  // --- 1. LOGIC: GET PRECISE GPS LOCATION ---
  Future<void> _fetchPreciseLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if GPS is on
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar("Please enable Location services on your phone.");
      setState(() => _isFetchingLocation = false);
      return;
    }

    // Check Permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar("Permission denied. Using City default.");
        setState(() => _isFetchingLocation = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar("Location permanently denied. Check Settings.");
      setState(() => _isFetchingLocation = false);
      return;
    }

    try {
      // Get Coordinates
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert to Address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          // Format: "Street, SubLocality, Locality"
          // Example: "Main Market Rd, Sreekrishnapuram, Palakkad"
          _currentLocation = "${place.street}, ${place.subLocality}, ${place.locality}";
          _isFetchingLocation = false;
        });
        _showSnackBar("Updated to precise location!");
      }
    } catch (e) {
      _showSnackBar("Error fetching GPS. Using City default.");
      setState(() => _isFetchingLocation = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // --- 2. LOGIC: SUBMIT DATA ---
  void _submitReport() {
    // Combine selected chips
    List<String> finalSymptoms = List.from(_selectedSymptoms);

    // Handle "Other" logic
    if (_selectedSymptoms.contains('Other')) {
      finalSymptoms.remove('Other'); // Remove the label "Other"
      if (_otherSymptomController.text.isNotEmpty) {
        finalSymptoms.add(_otherSymptomController.text.trim()); // Add the typed text
      }
    }

    // Validation
    if (finalSymptoms.isEmpty) {
      _showSnackBar("Please select at least one symptom.");
      return;
    }

    // Navigate to Review Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewSubmitScreen(
          symptoms: finalSymptoms.join(", "), // Converts list to "Fever, Cough"
          description: _descriptionController.text.trim(),
          location: _currentLocation, // Passes the final location (City or GPS)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Top App Bar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Report Symptoms",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PRIVACY BANNER (For Abstract) ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9), // Light Green
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.security, color: Colors.green, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Data is anonymized. Your identity is hidden to protect privacy.",
                      style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- SYMPTOM SELECTOR ---
            const Text(
              "Select all that apply:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _availableSymptoms.map((symptom) {
                final bool isSelected = _selectedSymptoms.contains(symptom);
                return FilterChip(
                  label: Text(symptom),
                  selected: isSelected,
                  // Color Styling
                  selectedColor: const Color(0xFF30B1D2).withOpacity(0.2),
                  checkmarkColor: const Color(0xFF30B1D2),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF30B1D2) : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  backgroundColor: Colors.grey[100],
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedSymptoms.add(symptom);
                      } else {
                        _selectedSymptoms.remove(symptom);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            // "Other" Text Field (Conditional)
            if (_selectedSymptoms.contains('Other')) ...[
              const SizedBox(height: 15),
              TextField(
                controller: _otherSymptomController,
                decoration: InputDecoration(
                  labelText: "Please specify other symptom",
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF30B1D2)),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 25),

            // --- LOCATION SECTION (Hybrid) ---
            const Text(
              "Location of Incident",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF30B1D2)),
                  const SizedBox(width: 10),

                  // Location Text
                  Expanded(
                    child: Text(
                      _currentLocation,
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),

                  // GPS Button
                  _isFetchingLocation
                      ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF30B1D2))
                  )
                      : IconButton(
                    icon: const Icon(Icons.my_location, color: Colors.grey),
                    tooltip: "Use Precise GPS",
                    onPressed: _fetchPreciseLocation,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 4, top: 5),
              child: Text(
                "Tip: Uses selected city by default. Tap target icon for exact street location.",
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ),

            const SizedBox(height: 25),

            // --- DESCRIPTION ---
            const Text("Additional Details (Optional)",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "e.g., Duration, severity...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 30),

            // --- SUBMIT BUTTON ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF30B1D2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Review & Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}