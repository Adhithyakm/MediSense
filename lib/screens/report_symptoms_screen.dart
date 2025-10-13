import 'package:flutter/material.dart';
import 'home_screen.dart'; // Make sure this path is correct

class ReportSymptomsScreen extends StatefulWidget {
  final String fullName;

  // FIX 1: Add a semicolon at the end of the constructor initialization list
  const ReportSymptomsScreen({Key? key, required this.fullName}) : super(key: key);

  @override
  State<ReportSymptomsScreen> createState() => _ReportSymptomsScreenState();
}

class _ReportSymptomsScreenState extends State<ReportSymptomsScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _otherSymptomController = TextEditingController();

  String? _selectedSymptom;
  final List<String> _symptoms = ['Cough', 'Fever', 'Headache', 'Other'];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            // FIX 2: Remove 'const' from HomeScreen because widget.fullName is not a compile-time constant
            builder: (context) => HomeScreen(fullName: widget.fullName),
          ),
        );
        break;
      case 1:
      // Navigate to Map (assuming MapScreen also takes fullName if needed)
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MapScreen(fullName: widget.fullName)));
        break;
      case 2:
      // Navigate to Tasks (assuming TasksScreen also takes fullName if needed)
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TasksScreen(fullName: widget.fullName)));
        break;
      case 3:
      // Navigate to Profile (assuming SetupProfileScreen also takes fullName if needed)
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SetupProfileScreen(fullName: widget.fullName)));
        break;
    }
  }

  void _submitReport() {
    String symptomToSave =
    _selectedSymptom == 'Other' ? _otherSymptomController.text.trim() : _selectedSymptom ?? '';

    if (symptomToSave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select or enter a symptom.")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Symptom '$symptomToSave' submitted successfully!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            // Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF30B1D2), width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: const Text("Select Symptoms",
                      style: TextStyle(color: Colors.grey)),
                  value: _selectedSymptom,
                  isExpanded: true,
                  items: _symptoms.map((String symptom) {
                    return DropdownMenuItem<String>(
                      value: symptom,
                      child: Text(symptom),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSymptom = value;
                    });
                  },
                ),
              ),
            ),

            // "Other symptom" field appears dynamically
            if (_selectedSymptom == 'Other') ...[
              const SizedBox(height: 15),
              TextField(
                controller: _otherSymptomController,
                decoration: InputDecoration(
                  labelText: "Enter other symptom",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF30B1D2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 25),

            // Description box
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF30B1D2)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 5,
                maxLength: 250,
                decoration: const InputDecoration(
                  hintText: "Brief Description",
                  counterText: "Limit 250",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Location
            const Text(
              "Confirm Location",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.location_on, color: Color(0xFF30B1D2)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Sreekrishnapuram, Palakkad District",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF30B1D2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Change Location tapped")),
                  );
                },
                child: const Text(
                  "Change Location",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Submit Button
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
                ),
                child: const Text(
                  "Save and Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF30B1D2),
        unselectedItemColor: Colors.black,
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