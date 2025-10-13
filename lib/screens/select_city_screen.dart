import 'package:flutter/material.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({super.key});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  String? selectedDistrict;
  String? selectedLocalBody;
  String? selectedWard;

  final List<String> districts = ["Ernakulam", "Trivandrum", "Kozhikode"];
  final List<String> localBodies = ["Municipality", "Panchayat", "Corporation"];
  final List<String> wards = ["Ward 1", "Ward 2", "Ward 3"];

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
          "Select City",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "In order to serve you better, Please select your location.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // City Options Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 15,
              children: [
                _cityOption("lib/assets/ernakulam.png", "Ernakulam"),
                _cityOption("lib/assets/trivandrum.png", "Trivandrum"),
                _cityOption("lib/assets/kozhikode.png", "Kozhikode"),
                _cityOption("lib/assets/thrissur.png", "Thrissur"),
                _cityOption("lib/assets/alappuzha.png", "Alappuzha"),
                _cityOption("lib/assets/palakkad.png", "Palakkad"),
              ],
            ),

            const SizedBox(height: 20),

            // Divider with "or search here"
            Row(
              children: const [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("or search here"),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),

            const SizedBox(height: 20),

            // District Dropdown
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              decoration: _dropdownDecoration("Select District"),
              items: districts.map((district) {
                return DropdownMenuItem(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedDistrict = value);
              },
            ),
            const SizedBox(height: 20),

            // Local Body Dropdown
            const Text("Select name of the local government body",
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedLocalBody,
              decoration: _dropdownDecoration("Select Local Body"),
              items: localBodies.map((body) {
                return DropdownMenuItem(
                  value: body,
                  child: Text(body),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedLocalBody = value);
              },
            ),
            const SizedBox(height: 20),

            // Ward Dropdown
            const Text("Select Ward", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedWard,
              decoration: _dropdownDecoration("Select Ward"),
              items: wards.map((ward) {
                return DropdownMenuItem(
                  value: ward,
                  child: Text(ward),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedWard = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable City Option Widget
  Widget _cityOption(String imagePath, String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.blue.shade50,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  // Reusable Dropdown Style
  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF30B1D2)),
      ),
    );
  }
}
