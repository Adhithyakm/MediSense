import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportCommunityRiskScreen extends StatefulWidget {
  const ReportCommunityRiskScreen({Key? key}) : super(key: key);

  @override
  State<ReportCommunityRiskScreen> createState() => _ReportCommunityRiskScreenState();
}

class _ReportCommunityRiskScreenState extends State<ReportCommunityRiskScreen> {
  String? selectedDistrict;
  String? selectedLocalBody;
  final TextEditingController locationController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? selectedImage;

  final List<String> districts = [
    'Palakkad',
    'Thrissur',
    'Ernakulam',
    'Kozhikode',
    'Thiruvananthapuram'
  ];

  final List<String> localBodies = [
    'Municipality',
    'Panchayat',
    'Corporation',
  ];

  final Color primaryColor = const Color(0xFF30B1D2);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  void submitForm() {
    if (selectedDistrict == null ||
        selectedLocalBody == null ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Community Risk Report Submitted Successfully!")),
    );

    setState(() {
      selectedDistrict = null;
      selectedLocalBody = null;
      locationController.clear();
      landmarkController.clear();
      descriptionController.clear();
      selectedImage = null;
    });
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          isExpanded: true,
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Report Community Risk",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter the details of the contaminated area and provide an image of the same",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            _buildDropdown(
              hint: "Select District",
              value: selectedDistrict,
              items: districts,
              onChanged: (val) => setState(() => selectedDistrict = val),
            ),
            _buildDropdown(
              hint: "Select Local Body",
              value: selectedLocalBody,
              items: localBodies,
              onChanged: (val) => setState(() => selectedLocalBody = val),
            ),
            _buildTextField(hint: "Name of the Location", controller: locationController),
            _buildTextField(hint: "Near by Landmark", controller: landmarkController),

            const SizedBox(height: 10),

            // File Picker Section
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: pickImage,
                    child: const Text(
                      "Choose File",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedImage != null
                          ? selectedImage!.path.split('/').last
                          : "No File Chosen",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "** The max file upload size is 25MB",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),

            _buildTextField(
              hint: "Brief Description",
              controller: descriptionController,
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save and Submit",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
