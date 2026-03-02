import 'package:flutter/material.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> report;
  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    // 1. Convert the UTC time from the server to the phone's Local Time (IST)
    DateTime dt = DateTime.parse(report['created_at']).toLocal();

    // 2. Format the Date (Adding padLeft to ensure 01/01/2026 instead of 1/1/2026)
    String day = dt.day.toString().padLeft(2, '0');
    String month = dt.month.toString().padLeft(2, '0');
    String formattedDate = "$day/$month/${dt.year}";

    // 3. Format to 12-hour clock (Fixes the 13:00 PM issue)
    int hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    if (hour == 0) hour = 12; // Handle Midnight
    String period = dt.hour >= 12 ? 'PM' : 'AM';
    String minute = dt.minute.toString().padLeft(2, '0');

    String formattedTime = "$hour:$minute $period";



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Detailed Analysis"), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCard("Location:", report['specific_address'], true),
            const SizedBox(height: 15),
            _buildCard("Symptoms / Description:", report['description'], false),
            const SizedBox(height: 15),
            _buildCard("AI Prediction:", "Condition identified as: ${report['predicted_disease']}", false),
            const SizedBox(height: 15),
            _buildCard("Timeline:", "Submitted on $formattedDate at $formattedTime", false),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value, bool isPending) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(border: Border.all(color: Colors.cyan.shade100), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
              if (isPending) Container(padding: const EdgeInsets.all(4), color: Colors.orange.shade50, child: const Text("Pending Review", style: TextStyle(fontSize: 10, color: Colors.orange)))
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}