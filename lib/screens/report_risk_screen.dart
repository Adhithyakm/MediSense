/*import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class ReportRiskScreen extends StatefulWidget {
  final String selectedCity;

  const ReportRiskScreen({
    super.key,
    required this.selectedCity,
  });

  @override
  State<ReportRiskScreen> createState() => _ReportRiskScreenState();
}

class _ReportRiskScreenState extends State<ReportRiskScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  String? selectedRiskType;
  late String _currentLocation;

  // Routing Data
  String _storedDistrict = "Unknown";
  String _storedLocalBody = "Unknown";
  int? _storedLocalBodyId; // CRITICAL: For routing to the correct official

  // GPS Mapping Data
  double? _lat;
  double? _lng;
  bool _isFetchingLocation = false;

  List<File> selectedImages = [];
  bool _isSubmitting = false;

  final Color primaryColor = const Color(0xFF30B1D2);
  final ImagePicker _picker = ImagePicker();

  final List<String> riskTypes = ['Stagnant Water', 'Garbage Dump', 'Dead Animal', 'Sewage', 'Other'];
  final String baseUrl = "http:// 192.168.24.71:8080/api/reports_api";

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.selectedCity;
    _loadStoredLocationDetails();
    _retrieveLostData();
  }

  Future<void> _retrieveLostData() async {
    if (Platform.isAndroid) {
      final LostDataResponse response = await _picker.retrieveLostData();
      if (response.file != null) {
        setState(() => selectedImages.add(File(response.file!.path)));
      }
    }
  }

  // Load the Routing ID and Names from City Selection Screen
  Future<void> _loadStoredLocationDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedDistrict = prefs.getString('selectedDistrict') ?? "Unknown";
      _storedLocalBody = prefs.getString('selectedLocalBody') ?? "Unknown";
      _storedLocalBodyId = prefs.getInt('selected_local_body_id'); // Ensure this was saved in City Selection
    });
  }

  // Captures both Address and Raw Coordinates
  Future<void> _fetchPreciseLocation() async {
    setState(() => _isFetchingLocation = true);

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        // Save raw coordinates for Geomapping
        _lat = position.latitude;
        _lng = position.longitude;

        List<Placemark> placemarks = await placemarkFromCoordinates(_lat!, _lng!);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            _currentLocation = "${place.street}, ${place.subLocality}, ${place.locality}";
          });
          _showSnack("Precise GPS location captured!");
        }
      }
    } catch (e) {
      _showSnack("GPS Error. Using city default.");
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  Future<void> showImageSourceOptions() async {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => Wrap(
          children: [
            ListTile(leading: const Icon(Icons.camera_alt), title: const Text("Camera"), onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); }),
            ListTile(leading: const Icon(Icons.photo_library), title: const Text("Gallery"), onTap: () { Navigator.pop(ctx); _pickMultiImages(); })
          ],
        )
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source, imageQuality: 40);
    if (picked != null) setState(() => selectedImages.add(File(picked.path)));
  }

  Future<void> _pickMultiImages() async {
    final List<XFile> pickedList = await _picker.pickMultiImage(imageQuality: 40);
    if (pickedList.isNotEmpty) setState(() => selectedImages.addAll(pickedList.map((x) => File(x.path)).toList()));
  }

  // --- REFINED SUBMIT LOGIC ---
  Future<void> submitForm() async {
    if (selectedRiskType == null || selectedImages.isEmpty) {
      _showSnack("Please select Risk Type and at least one image.");
      return;
    }

    if (_storedLocalBodyId == null) {
      _showSnack("Error: Local Body ID missing. Please select your city again.");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? rawToken = prefs.getString('token');

      // Privacy: Generate Anonymous ID
      String anonymousId = "guest";
      if (rawToken != null) {
        var bytes = utf8.encode(rawToken + "PROJECT_SALT_IMAGE");
        anonymousId = sha256.convert(bytes).toString();
      }

      var uri = Uri.parse("$baseUrl/submit-risk/");
      var request = http.MultipartRequest('POST', uri);

      if (rawToken != null) request.headers['Authorization'] = "Token $rawToken";

      // --- MATCHING BACKEND FIELDS ---
      request.fields['local_body_id'] = _storedLocalBodyId.toString(); // For Routing
      request.fields['risk_type'] = selectedRiskType!;
      request.fields['location_address'] = _currentLocation; // Street Address
      request.fields['latitude'] = (_lat ?? 0.0).toString(); // For Mapping
      request.fields['longitude'] = (_lng ?? 0.0).toString(); // For Mapping
      request.fields['description'] = "${descriptionController.text} | Landmark: ${landmarkController.text}";
      request.fields['anonymous_id'] = anonymousId;

      // Attach Images
      for (var img in selectedImages) {
        request.files.add(await http.MultipartFile.fromPath("image", img.path));
      }

      var response = await request.send();

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        _showSnack("Failed: ${response.statusCode}");
      }
    } catch (e) {
      _showSnack("Connection Error: $e");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Risk Reported ✅"),
        content: const Text("Data and images have been anonymized and sent to the local health official for verification."),
        actions: [
          TextButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const HomeScreen()), (r) => false), child: const Text("OK"))
        ],
      ),
    );
  }

  // ... (UI Helpers _buildDropdown and _buildTextField stay exactly the same as your provided code) ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text("Report Community Risk", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("This photo will be analyzed by AI to help identify potential outbreaks.", style: TextStyle(fontSize: 13, color: Colors.blueGrey)),
            const SizedBox(height: 20),

            _buildDropdown(
              hint: "Select Risk Type",
              value: selectedRiskType,
              items: riskTypes,
              onChanged: (val) => setState(() => selectedRiskType = val),
            ),

            const SizedBox(height: 10),

            // Location Preview Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF30B1D2)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_currentLocation, style: const TextStyle(fontSize: 14))),
                  _isFetchingLocation
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : IconButton(icon: const Icon(Icons.my_location, color: Colors.blueGrey), onPressed: _fetchPreciseLocation),
                ],
              ),
            ),

            const SizedBox(height: 15),
            _buildTextField(hint: "Nearby Landmark", controller: landmarkController),
            const SizedBox(height: 15),

            // Image Picker Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: primaryColor.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: showImageSourceOptions,
                    icon: const Icon(Icons.add_a_photo, color: Colors.white, size: 18),
                    label: const Text("Add Evidence Photos", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[800]),
                  ),
                  const SizedBox(height: 10),
                  selectedImages.isEmpty
                      ? const Text("No photos selected", style: TextStyle(color: Colors.grey, fontSize: 12))
                      : SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length,
                      itemBuilder: (context, index) => Stack(
                        children: [
                          Container(margin: const EdgeInsets.only(right: 10), width: 100, height: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), image: DecorationImage(image: FileImage(selectedImages[index]), fit: BoxFit.cover))),
                          Positioned(right: 5, top: 0, child: GestureDetector(onTap: () => setState(() => selectedImages.removeAt(index)), child: const CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Icon(Icons.close, size: 14, color: Colors.white)))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            _buildTextField(hint: "Brief Description (Optional)", controller: descriptionController, maxLines: 4),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify and Submit", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Reusable components stay the same as your code ---
  Widget _buildDropdown({required String hint, required String? value, required List<String> items, required void Function(String?) onChanged}) {
    return Container(margin: const EdgeInsets.symmetric(vertical: 8), padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(10)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(hint: Text(hint), isExpanded: true, value: value, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged)));
  }

  Widget _buildTextField({required String hint, required TextEditingController controller, int maxLines = 1}) {
    return Container(margin: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(10)), child: TextField(controller: controller, maxLines: maxLines, decoration: InputDecoration(hintText: hint, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12))));
  }
}*/
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class ReportRiskScreen extends StatefulWidget {
  final String selectedCity;

  const ReportRiskScreen({
    super.key,
    required this.selectedCity,
  });

  @override
  State<ReportRiskScreen> createState() => _ReportRiskScreenState();
}

class _ReportRiskScreenState extends State<ReportRiskScreen> {
  // --- CONTROLLERS ---
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  // --- STATE VARIABLES ---
  String? selectedRiskType;
  late String _currentLocation;

  // Routing & Mapping Data
  String _storedDistrict = "Unknown";
  String _storedLocalBody = "Unknown";
  int? _storedLocalBodyId;
  double? _lat;
  double? _lng;

  bool _isFetchingLocation = false;
  List<File> selectedImages = [];
  bool _isSubmitting = false;

  final Color primaryColor = const Color(0xFF30B1D2);
  final ImagePicker _picker = ImagePicker();

  final List<String> riskTypes = [
    'Stagnant Water',
    'Garbage Dump',
    'Dead Animal',
    'Sewage',
    'Mosquito Breeding',
    'Other'
  ];

  // 🟢 UPDATE THIS IP to match your current laptop IP
  final String baseUrl = "http://192.168.24.71:8080/api/reports_api";

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.selectedCity;
    _loadStoredLocationDetails();
    _retrieveLostData();
  }

  // Prevents losing images if Android kills the app during camera usage
  Future<void> _retrieveLostData() async {
    if (Platform.isAndroid) {
      final LostDataResponse response = await _picker.retrieveLostData();
      if (response.file != null) {
        setState(() => selectedImages.add(File(response.file!.path)));
      }
    }
  }
  void _showSnack(String msg) {
    if (!mounted) return; // Safety check
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
  // Load the Routing ID saved during City Selection
  Future<void> _loadStoredLocationDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedDistrict = prefs.getString('selectedDistrict') ?? "Unknown";
      _storedLocalBody = prefs.getString('selectedLocalBody') ?? "Unknown";
      _storedLocalBodyId = prefs.getInt('selected_local_body_id');
    });
  }

  // Captures both Address string and numeric GPS coordinates for the map
  Future<void> _fetchPreciseLocation() async {
    setState(() => _isFetchingLocation = true);
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        _lat = position.latitude;
        _lng = position.longitude;

        List<Placemark> placemarks = await placemarkFromCoordinates(_lat!, _lng!);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            _currentLocation = "${place.street}, ${place.subLocality}, ${place.locality}";
          });
          _showSnack("Precise GPS location captured!");
        }
      }
    } catch (e) {
      _showSnack("GPS Error. Using city default.");
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  // --- IMAGE PICKER ---
  Future<void> showImageSourceOptions() async {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery (Select from device)"),
              onTap: () { Navigator.pop(ctx); _pickMultiImages(); },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera (Take Photo)"),
              onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); },
            )

          ],
        )
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source, imageQuality: 40);
    if (picked != null) setState(() => selectedImages.add(File(picked.path)));
  }

  Future<void> _pickMultiImages() async {
    final List<XFile> pickedList = await _picker.pickMultiImage(imageQuality: 40);
    if (pickedList.isNotEmpty) setState(() => selectedImages.addAll(pickedList.map((x) => File(x.path)).toList()));
  }

  // --- SUBMIT LOGIC (Multi-Modal + Federated Privacy) ---
  Future<void> submitForm() async {
    // 1. Basic validation
    if (selectedRiskType == null || selectedImages.isEmpty) {
      _showSnack("Please select Risk Type and provide a photo.");
      return;
    }
    if (_storedLocalBodyId == null) {
      _showSnack("Location ID missing. Please re-select your city.");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // 🟢 FIX 1: Define 'token' and 'prefs' at the top
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // 🟢 FIX 2: Define 'uri' properly
      final Uri uri = Uri.parse("$baseUrl/submit-risk/");

      // 🟢 FIX 3: Define 'anonymousId' OUTSIDE the if-block so it can be used later
      String anonymousId = "guest";
      if (token != null) {
        var bytes = utf8.encode(token + "PROJECT_SALT_IMAGE");
        anonymousId = sha256.convert(bytes).toString();
      }

      // 🟢 Now 'uri', 'token', and 'anonymousId' are all valid and usable below:
      var request = http.MultipartRequest('POST', uri);

      if (token != null) {
        request.headers['Authorization'] = "Token $token";
      }

      // 🟢 DATA FIELDS (Mapped to your Django Logic)
      request.fields['local_body_id'] = _storedLocalBodyId.toString();
      request.fields['risk_type'] = selectedRiskType!;
      request.fields['location_address'] = _currentLocation;

      // Combine Landmark and Description so it's not lost
      String landmark = landmarkController.text.trim();
      String notes = descriptionController.text.trim();
      request.fields['description'] = "Landmark: $landmark | Notes: $notes";

      request.fields['latitude'] = (_lat ?? 0.0).toString();
      request.fields['longitude'] = (_lng ?? 0.0).toString();
      request.fields['anonymous_id'] = anonymousId;

      // 🟢 ATTACH IMAGES
      for (var img in selectedImages) {
        request.files.add(await http.MultipartFile.fromPath("image", img.path));
      }

      // 🟢 SEND AND GET RESPONSE
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var result = jsonDecode(response.body);
        // Show the AI result returned from the Python server
        _showSuccessDialog(result['ai_detected'] ?? "Risk Reported");
      } else {
        _showSnack("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Connection Error: $e");
      _showSnack("Error: Could not connect to server. Check Laptop IP.");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
  void _showSuccessDialog(String aiPrediction) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Risk Reported ✅"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your evidence has been anonymized and sent to health officials."),
            const SizedBox(height: 15),
            const Text("AI Vision Detection:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(aiPrediction, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const HomeScreen()), (r) => false),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text("Report Community Risk", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Help identify environmental hazards by uploading clear photos for AI analysis.",
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 25),

            _buildDropdown(hint: "Type of Risk", value: selectedRiskType, items: riskTypes,
                onChanged: (val) => setState(() => selectedRiskType = val)),

            const SizedBox(height: 10),

            // Location Indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF30B1D2)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_currentLocation, style: const TextStyle(fontSize: 14))),
                  _isFetchingLocation
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : IconButton(icon: const Icon(Icons.my_location, color: Colors.blueGrey), onPressed: _fetchPreciseLocation),
                ],
              ),
            ),

            const SizedBox(height: 15),
            _buildTextField(hint: "Nearby Landmark (e.g., Near Bus Stand)", controller: landmarkController),
            const SizedBox(height: 15),

            // Image Selection Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(border: Border.all(color: primaryColor.withOpacity(0.3)), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: showImageSourceOptions,
                    icon: const Icon(Icons.add_a_photo, color: Colors.white, size: 18),
                    label: const Text("Add Photo Evidence", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[800]),
                  ),
                  const SizedBox(height: 15),
                  selectedImages.isEmpty
                      ? const Text("No photos attached yet.", style: TextStyle(color: Colors.grey, fontSize: 12))
                      : SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length,
                      itemBuilder: (context, index) => Stack(
                        children: [
                          Container(margin: const EdgeInsets.only(right: 12), width: 120, height: 120, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: FileImage(selectedImages[index]), fit: BoxFit.cover))),
                          Positioned(right: 5, top: 0, child: GestureDetector(onTap: () => setState(() => selectedImages.removeAt(index)), child: const CircleAvatar(radius: 12, backgroundColor: Colors.red, child: Icon(Icons.close, size: 14, color: Colors.white)))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            _buildTextField(hint: "Additional Notes (Optional)", controller: descriptionController, maxLines: 3),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Confirm & Submit Evidence", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---
  Widget _buildDropdown({required String hint, required String? value, required List<String> items, required void Function(String?) onChanged}) {
    return Container(margin: const EdgeInsets.symmetric(vertical: 8), padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(10)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(hint: Text(hint), isExpanded: true, value: value, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged)));
  }

  Widget _buildTextField({required String hint, required TextEditingController controller, int maxLines = 1}) {
    return Container(margin: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(10)), child: TextField(controller: controller, maxLines: maxLines, decoration: InputDecoration(hintText: hint, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12))));
  }
}
