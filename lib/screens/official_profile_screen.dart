import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'health_login.dart'; // For Logout

class OfficialProfileScreen extends StatefulWidget {
  const OfficialProfileScreen({super.key});

  @override
  State<OfficialProfileScreen> createState() => _OfficialProfileScreenState();
}

class _OfficialProfileScreenState extends State<OfficialProfileScreen> {
  bool isLoading = true;
  Map<String, dynamic> profileData = {};

  // 🟢 Update IP
  final String baseUrl = "http://192.168.24.71:8080/api/accounts/profile/";

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          profileData = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreens()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Official Profile"),
        backgroundColor: const Color(0xFF22B7E9), // Official Red
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF22B7E9)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- ID CARD STYLE HEADER ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFFFEBEE),
                    child: Icon(Icons.local_hospital, size: 50, color: Color(0xFF22B7E9)),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    profileData['full_name'] ?? "Health Official",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    profileData['username'] ?? "ID: Unknown",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22B7E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "AUTHORIZED OFFICER",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- JURISDICTION DETAILS ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Assigned Jurisdiction", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            const SizedBox(height: 10),
            _buildInfoCard(Icons.map, "District", profileData['district'] ?? "N/A"),
            _buildInfoCard(Icons.location_city, "Local Body Name", profileData['local_body_name'] ?? "N/A"),
            _buildInfoCard(Icons.category, "Type", profileData['local_body_type'] ?? "N/A"),

            const SizedBox(height: 20),

            // --- CONTACT DETAILS ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Contact Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            const SizedBox(height: 10),
            _buildInfoCard(Icons.phone, "Mobile", profileData['mobile_number'] ?? "N/A"),
            _buildInfoCard(Icons.email, "System Email", profileData['email'] ?? "N/A"),

            const SizedBox(height: 30),

            // --- LOGOUT BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("Secure Logout", style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF22B7E9)),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
    );
  }
}