import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart'; // Ensure this import is correct in your project

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({super.key});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  // =========================================================
  // LOGIC & STATE VARIABLES (From your Logic Code)
  // =========================================================

  // --- Selected Values ---
  String? selectedDistrict;
  String? selectedBodyType;
  String? selectedLocalBody;

  // --- Data Lists ---
  List<String> districts = [];
  List<String> bodyTypes = [];
  List<String> localBodies = [];

  // --- State Variables ---
  bool _isInitializing = true;
  bool _isLoadingBodyTypes = false;
  bool _isLoadingLocalBodies = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _token;

  // Asset paths (Matching the UI Image)
  // Note: These keys must match the District names coming from your API
  // for the click to work automatically.
  final Map<String, String> districtAssetPaths = {
    'Ernakulam': 'lib/assets/ernakulam.png',
    'Trivandrum': 'lib/assets/trivandrum.png',
    'Kozhikode': 'lib/assets/kozhikode.png',
    'Thrissur': 'lib/assets/thrissur.png',
    'Alappuzha': 'lib/assets/alappuzha.png',
    'Palakkad': 'lib/assets/palakkad.png',
  };

  final String baseUrl = "http://10.69.161.158:8080/api/reports_api";
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // =========================================================
  // API & LOGIC METHODS (Exactly as provided)
  // =========================================================

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> _initializeData() async {
    _token = await _getToken();
    if (_token == null) {
      if (mounted) {
        setState(() {
          _errorMessage = "Authentication failed: Token not found.";
          _isInitializing = false;
        });
      }
      return;
    }
    await fetchDistricts();
    if (mounted) setState(() => _isInitializing = false);
  }

  Options _authOptions() {
    return Options(headers: {"Authorization": "Token $_token"});
  }

  Future<void> fetchDistricts() async {
    if (mounted) setState(() => _errorMessage = null);
    try {
      final response = await _dio.get("$baseUrl/districts/", options: _authOptions());
      if (mounted) {
        setState(() {
          districts = List<String>.from(response.data['districts']);
        });
      }
    } on DioException catch (e) {
      if (mounted) setState(() => _errorMessage = "Failed to load districts: ${e.response?.statusCode ?? 'Network Error'}");
    }
  }

  void _resetDependentFields() {
    selectedBodyType = null;
    selectedLocalBody = null;
    bodyTypes = [];
    localBodies = [];
  }

  Future<void> fetchBodyTypes(String district) async {
    if (mounted) setState(() {
      _isLoadingBodyTypes = true; _errorMessage = null; _resetDependentFields();
    });
    try {
      final response = await _dio.get("$baseUrl/body-types/", queryParameters: {"district": district}, options: _authOptions());
      if (mounted) setState(() => bodyTypes = List<String>.from(response.data['body_types']));
    } on DioException catch (e) {
      if (mounted) setState(() => _errorMessage = "Failed to load body types: ${e.response?.statusCode ?? 'Network Error'}");
    } finally {
      if (mounted) setState(() => _isLoadingBodyTypes = false);
    }
  }

  Future<void> fetchLocalBodies(String district, String bodyType) async {
    if (mounted) setState(() {
      _isLoadingLocalBodies = true; _errorMessage = null; selectedLocalBody = null; localBodies = [];
    });
    try {
      final response = await _dio.get("$baseUrl/local-bodies/", queryParameters: {"district": district, "body_type": bodyType}, options: _authOptions());
      if (mounted) setState(() => localBodies = List<String>.from(response.data['local_bodies']));
    } on DioException catch (e) {
      if (mounted) setState(() => _errorMessage = "Failed to load local bodies: ${e.response?.statusCode ?? 'Network Error'}");
    } finally {
      if (mounted) setState(() => _isLoadingLocalBodies = false);
    }
  }

  Future<void> _submitLocation() async {
    if (selectedDistrict == null || selectedLocalBody == null) {
      setState(() => _errorMessage = "Please select District and Local Body.");
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedDistrict', selectedDistrict!);
      await prefs.setString('selectedBodyType', selectedBodyType ?? '');
      await prefs.setString('selectedLocalBody', selectedLocalBody!);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = "Submission failed: $e");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // =========================================================
  // UI BUILD METHOD (Matches First Image)
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top "Location" Text
              Text(
                'Location',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),

              // 2. Back Arrow and Title
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios, size: 24, color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Select City',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 3. Subtitle
              const Text(
                'In order to serve you better, Please select\nyour location.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // 4. City Grid (Visuals from Image 1, Logic from API)
              // We display the 6 static options from the design.
              // Clicking them sets the 'selectedDistrict' in the logic.
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 15,
                childAspectRatio: 0.8,
                children: [
                  // Note: Ensure the string 'Ernakulam' matches exactly what your API returns
                  _buildCityItem('Ernakulam', 'lib/assets/ernakulam.png'),
                  _buildCityItem('Trivandrum', 'lib/assets/trivandrum.png'),
                  _buildCityItem('Kozhikode', 'lib/assets/kozhikode.png'),
                  _buildCityItem('Thrissur', 'lib/assets/thrissur.png'),
                  _buildCityItem('Alappuzha', 'lib/assets/alappuzha.png'),
                  _buildCityItem('Palakkad', 'lib/assets/palakkad.png'),
                ],
              ),

              const SizedBox(height: 20),

              // 5. "or search here" Divider
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'or search here',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 20),

              // --- Error Message Display ---
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),

              // 6. Dropdown 1: Select District
              _buildCustomDropdown(
                hint: _isInitializing ? "Loading Districts..." : "Select District",
                value: selectedDistrict,
                items: districts,
                onChanged: (val) {
                  setState(() {
                    selectedDistrict = val;
                    _resetDependentFields();
                  });
                  if (val != null) fetchBodyTypes(val);
                },
              ),
              const SizedBox(height: 15),

              // 7. Dropdown 2: Body Type (Matches Logic: "Select name of the local government body")
              // Note: In logic code this is Body Type, in UI Image it says "Select name of..."
              // We keep logic structure but use UI styling.
              const Text(
                'Select local government body type',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildCustomDropdown(
                hint: _isLoadingBodyTypes ? "Loading..." : "Select Body Type",
                value: selectedBodyType,
                items: bodyTypes,
                onChanged: (val) {
                  setState(() => selectedBodyType = val);
                  if (val != null && selectedDistrict != null) {
                    fetchLocalBodies(selectedDistrict!, val);
                  }
                },
              ),

              const SizedBox(height: 15),

              // 8. Dropdown 3: Local Body (Matches Logic: "Select Local Body")
              // In the UI image this was "Select Block". We must use "Select Local Body" to match logic.
              const Text(
                'Select Local Body',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildCustomDropdown(
                hint: _isLoadingLocalBodies ? "Loading..." : "Select Local Body",
                value: selectedLocalBody,
                items: localBodies,
                onChanged: (val) {
                  setState(() => selectedLocalBody = val);
                },
              ),

              const SizedBox(height: 30),

              // 9. Submit Button (Required by Logic)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (_isSubmitting || selectedLocalBody == null)
                      ? null
                      : _submitLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Matches the UI theme
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // HELPER WIDGETS (VISUAL STYLING from Image 1)
  // =========================================================

  Widget _buildCityItem(String name, String assetPath) {
    bool isSelected = selectedDistrict == name;

    return InkWell(
      onTap: () {
        // When Grid Icon is clicked, we update the Logic
        setState(() {
          selectedDistrict = name;
          _resetDependentFields();
        });
        // Try to fetch body types for this district
        fetchBodyTypes(name);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                // Change color if selected to give feedback
                color: isSelected ? Colors.blue.withOpacity(0.3) : const Color(0xFFE3F2FD),
                shape: BoxShape.circle,
                border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.location_city, color: Colors.blue);
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.blue : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.lightBlueAccent), // The Blue Border from Image 1
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: (items.contains(value)) ? value : null, // Safety check
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          isExpanded: true,
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}