import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'select_city_screen.dart';
class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  String selectedGender = "";
  String profileMessage = "";

  // Text controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Set Up Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Skip", style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ... (rest of the build method, unchanged) ...

            // Profile image stack and other UI components

            Stack(
              children: [
                const CircleAvatar(radius: 55, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 60, color: Colors.white)),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF30B1D2),
                    radius: 18,
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Personal Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            const Divider(),
            const SizedBox(height: 10),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: const Icon(Icons.person, color: Color(0xFF30B1D2)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Mobile Number",
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF30B1D2)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Date Of Birth", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _dobField("Date", dateController),
                _dobField("Month", monthController),
                _dobField("Year", yearController),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => selectedGender = "Male"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedGender == "Male" ? const Color(0xFF30B1D2) : Colors.white,
                      foregroundColor: selectedGender == "Male" ? Colors.white : Colors.black,
                      side: const BorderSide(color: Color(0xFF30B1D2)),
                    ),
                    child: const Text("Male"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => selectedGender = "Female"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedGender == "Female" ? const Color(0xFF30B1D2) : Colors.white,
                      foregroundColor: selectedGender == "Female" ? Colors.white : Colors.black,
                      side: const BorderSide(color: Color(0xFF30B1D2)),
                    ),
                    child: const Text("Female"),
                  ),
                ),
              ],
            ),
            if (profileMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  profileMessage,
                  style: TextStyle(
                    color: profileMessage.startsWith("Profile updated") ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF30B1D2),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dobField(String label, TextEditingController controller) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
      profileMessage = ""; // Clear previous message
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    if (token.isEmpty) {
      setState(() {
        isLoading = false;
        profileMessage = "Error: Authentication token not found in storage.";
      });
      return;
    }

    final url = Uri.parse("http://192.168.24.71:8080/api/accounts/profile/");

    print("Sending request with Token: $token");

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          // 🛑 FIX 2: Correct scheme ('Token') and trying lowercase header ('authorization') for robustness
          "authorization": "Token $token",
        },
        body: json.encode({
          "full_name": fullNameController.text,
          "mobile_number": mobileController.text,
          "date_of_birth": "${yearController.text}-${monthController.text.padLeft(2, '0')}-${dateController.text.padLeft(2, '0')}",
          "gender": selectedGender,
        }),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        setState(() {
          profileMessage = "Profile updated successfully!";
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SelectCityScreen()),
        );

      } else {
        print("Error Response: ${response.body}");
        String errorDetail = "Failed to update profile.";
        try {
          final errorData = jsonDecode(response.body);
          errorDetail = errorData['detail']?.toString() ?? errorData.toString();
        } catch (_) {
          errorDetail = "Server error (Status ${response.statusCode})";
        }
        setState(() {
          profileMessage = "Error: $errorDetail";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        profileMessage = "Network Error: Could not reach the server.";
      });
      print("Exception during profile update: $e");
    }
  }
}