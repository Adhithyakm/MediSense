import 'package:flutter/material.dart';
import '../models/report_model.dart';
import 'report_details_screen.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({Key? key}) : super(key: key);

  // TEMPORARY SAMPLE DATA (You will replace this with DB data later)
  final List<ReportModel> reports = [
    ReportModel(
      title: "Fever, Cold & Body Ache",
      symptoms: ["Fever", "Cold", "Body Ache"],
      description: "Feeling unwell for days. Fever with body ache.",
      district: "Thrissur",
      locality: "Ollukkara",
      date: "24/10/2025",
      time: "06:00 AM",
    ),
    ReportModel(
      title: "Sore Throat & Cough",
      symptoms: ["Sore Throat", "Cough"],
      description: "Severe throat pain and persistent cough.",
      district: "Kozhikode",
      locality: "Kunnamangalam",
      date: "15/09/2025",
      time: "10:30 AM",
    ),
    ReportModel(
      title: "Overflowing Sewage",
      symptoms: ["Sanitation Issue"],
      description: "Sewage overflow near bus stop.",
      district: "Ernakulam",
      locality: "Kalamassery",
      date: "03/07/2025",
      time: "08:15 AM",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: const [
                  Icon(Icons.arrow_back, size: 28),
                  SizedBox(width: 8),
                  Text(
                    "My Reports",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // List of reports
              Expanded(
                child: ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReportDetailsScreen(report: report),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF30B1D2)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report.title,
                                  style: const TextStyle(
                                    color: Color(0xFF30B1D2),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Uploaded on: ${report.date}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
