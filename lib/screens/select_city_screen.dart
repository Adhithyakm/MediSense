import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({super.key});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  String? selectedDistrict;
  String? selectedBodyType;
  Map<String, dynamic>? selectedLocalBodyObject;

  List<String> districts = [];
  List<String> bodyTypes = [];
  List<dynamic> localBodies = [];

  bool _isInitializing = true;
  bool _isLoadingBodyTypes = false;
  bool _isLoadingLocalBodies = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _token;

  // 🟢 BASE URL (Ensure this matches your current Laptop IP)
  final String baseUrl = "http://192.168.24.71:8080/api";
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");

    if (_token == null) {
      setState(() {
        _errorMessage = "Login session expired. Please login again.";
        _isInitializing = false;
      });
      return;
    }
    await fetchDistricts();
    if (mounted) setState(() => _isInitializing = false);
  }

  Options _authOptions() {
    return Options(headers: {"Authorization": "Token $_token"});
  }

  Future<void> fetchDistricts() async {
    try {
      final response = await _dio.get("$baseUrl/reports_api/districts/", options: _authOptions());
      if (mounted) {
        setState(() {
          districts = List<String>.from(response.data['districts']);
        });
      }
    } catch (e) {
      setState(() => _errorMessage = "Server unreachable. Check internet.");
    }
  }

  Future<void> fetchBodyTypes(String district) async {
    setState(() { _isLoadingBodyTypes = true; _resetDependentFields(); });
    try {
      final response = await _dio.get("$baseUrl/reports_api/body-types/",
          queryParameters: {"district": district}, options: _authOptions());
      if (mounted) setState(() => bodyTypes = List<String>.from(response.data['body_types']));
    } catch (e) {
      setState(() => _errorMessage = "Error loading types.");
    } finally {
      if (mounted) setState(() => _isLoadingBodyTypes = false);
    }
  }

  Future<void> fetchLocalBodies(String district, String bodyType) async {
    setState(() { _isLoadingLocalBodies = true; selectedLocalBodyObject = null; localBodies = []; });
    try {
      final response = await _dio.get("$baseUrl/reports_api/local-bodies/",
          queryParameters: {"district": district, "body_type": bodyType},
          options: _authOptions()
      );
      if (mounted) setState(() => localBodies = response.data['local_bodies']);
    } catch (e) {
      setState(() => _errorMessage = "Error loading cities.");
    } finally {
      if (mounted) setState(() => _isLoadingLocalBodies = false);
    }
  }

  void _resetDependentFields() {
    selectedBodyType = null;
    selectedLocalBodyObject = null;
    bodyTypes = [];
    localBodies = [];
  }

  // 🟢 THE AUTOMATIC SAVE LOGIC
  Future<void> _submitLocation() async {
    if (selectedDistrict == null || selectedLocalBodyObject == null) {
      setState(() => _errorMessage = "Please select District and Local Body.");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // 1. Update the User Profile on the Server (Critical for Alerts)
      await _dio.put(
        "$baseUrl/accounts/profile/",
        data: {
          "local_body_name": selectedLocalBodyObject!['local_body_name'],
          "district": selectedDistrict,
          "local_body_type": selectedBodyType,
        },
        options: _authOptions(),
      );

      // 2. Save everything locally in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedDistrict', selectedDistrict!);
      await prefs.setString('selectedLocalBody', selectedLocalBodyObject!['local_body_name']);
      await prefs.setInt('selected_local_body_id', selectedLocalBodyObject!['id']);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      setState(() => _errorMessage = "Database Error: Ensure your laptop is online.");
      print("Sync Error: $e");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Select City"), backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Identify Your Location', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 20),

            // Grid Icons
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              children: [
                _buildCityItem('Ernakulam', 'lib/assets/ernakulam.png'),
                _buildCityItem('Trivandrum', 'lib/assets/trivandrum.png'),
                _buildCityItem('Alappuzha', 'lib/assets/alappuzha.png'),
                _buildCityItem('Palakkad', 'lib/assets/palakkad.png'),
                _buildCityItem('Kozhikode', 'lib/assets/kozhikode.png'),
                _buildCityItem('Thrissur', 'lib/assets/thrissur.png'),
              ],
            ),

            const SizedBox(height: 30),
            if (_errorMessage != null) Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

            _buildDistrictDropdown(),
            const SizedBox(height: 15),
            _buildBodyTypeDropdown(),
            const SizedBox(height: 15),
            _buildLocalBodyDropdown(),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (_isSubmitting || selectedLocalBodyObject == null) ? null : _submitLocation,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF30B1D2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text("Set Location", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Dropdown Widgets ---
  Widget _buildDistrictDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.cyan.shade100), borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedDistrict,
          hint: const Text("Select District"),
          isExpanded: true,
          items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
          onChanged: (val) { setState(() => selectedDistrict = val); if (val != null) fetchBodyTypes(val); },
        ),
      ),
    );
  }

  Widget _buildBodyTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.cyan.shade100), borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedBodyType,
          hint: Text(_isLoadingBodyTypes ? "Loading..." : "Select Local Body Type"),
          isExpanded: true,
          items: bodyTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (val) { setState(() => selectedBodyType = val); if (val != null && selectedDistrict != null) fetchLocalBodies(selectedDistrict!, val); },
        ),
      ),
    );
  }

  Widget _buildLocalBodyDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.cyan.shade100), borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Map<String, dynamic>>(
          value: selectedLocalBodyObject,
          hint: Text(_isLoadingLocalBodies ? "Loading..." : "Select Specific Panchayat/City"),
          isExpanded: true,
          items: localBodies.map((body) => DropdownMenuItem<Map<String, dynamic>>(value: body, child: Text(body['local_body_name']))).toList(),
          onChanged: (val) => setState(() => selectedLocalBodyObject = val),
        ),
      ),
    );
  }

  Widget _buildCityItem(String name, String assetPath) {
    bool isSelected = selectedDistrict == name;
    return InkWell(
      onTap: () { setState(() => selectedDistrict = name); fetchBodyTypes(name); },
      child: Column(
        children: [
          Expanded(child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: isSelected ? Colors.cyan.shade50 : Colors.grey.shade50, shape: BoxShape.circle, border: isSelected ? Border.all(color: const Color(0xFF30B1D2), width: 2) : null),
              child: Image.asset(assetPath, fit: BoxFit.contain))),
          Text(name, style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}