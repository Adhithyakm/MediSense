import 'package:flutter/material.dart';

class ReviewSubmitScreen extends StatefulWidget {
  final String symptoms;
  final String description;
  final String location;

  const ReviewSubmitScreen({
    Key? key,
    required this.symptoms,
    required this.description,
    required this.location,
  }) : super(key: key);

  @override
  State<ReviewSubmitScreen> createState() => _ReviewSubmitScreenState();
}

class _ReviewSubmitScreenState extends State<ReviewSubmitScreen> {
  bool consentGiven = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Review & Submit",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Review Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF30B1D2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "You are submitting the following data",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Icon(Icons.medical_services, color: Color(0xFF30B1D2)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text("Symptoms : ${widget.symptoms}"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.description, color: Color(0xFF30B1D2)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text("Description : ${widget.description}"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Color(0xFF30B1D2)),
                      SizedBox(width: 10),
                    ],
                  ),
                  Text("Location : ${widget.location}"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Privacy & Consent
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF30B1D2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.privacy_tip, color: Color(0xFF30B1D2)),
                      SizedBox(width: 10),
                      Text(
                        "Privacy & Consent",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Your privacy is our priority. The health data you submit will be anonymized and used only for community health analysis.",
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Checkbox(
                        value: consentGiven,
                        onChanged: (value) {
                          setState(() {
                            consentGiven = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "I understand and consent to submit my anonymized health data.",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: consentGiven
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Report submitted successfully!")),
                  );
                  Navigator.pop(context);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF30B1D2),
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit",
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
    );
  }
}
