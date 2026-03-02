import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'report_details_screenofficial.dart';

class ResidentListScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const ResidentListScreen({super.key, required this.data});

  @override
  State<ResidentListScreen> createState() => _ResidentListScreenState();
}

class _ResidentListScreenState extends State<ResidentListScreen> {
  Set<String> sentAlerts = {};

  // 🟢 IMPORTANT: Ensure this IP is exactly what 'ipconfig' shows on your laptop
  final String baseUrl = "http://192.168.24.71:8080/api/reports_api";

  Future<void> _triggerClusterAlert(BuildContext context, String disease) async {
    // 🟢 DEBUG 1: Check if button press is detected
    print("🚀 ALERT BUTTON CLICKED for disease: $disease");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("❌ ERROR: No Token found in SharedPreferences");
      return;
    }

    // 🟢 DEBUG 2: Verify the URL formatting
    final String requestUrl = "$baseUrl/trigger-community-alert/";
    print("📡 ATTEMPTING REQUEST TO: $requestUrl");

    try {
      final response = await http.post(
        Uri.parse(requestUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({"disease": disease}),
      ).timeout(const Duration(seconds: 10)); // Stop waiting after 10 seconds

      // 🟢 DEBUG 3: Verify server response
      print("📡 SERVER RESPONSE CODE: ${response.statusCode}");
      print("📡 SERVER RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          sentAlerts.add(disease.toLowerCase().trim());
        });

        if (!mounted) return;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Broadcast Successful 📢"),
            content: const Text("All registered residents in this Panchayat have been notified via Push Notification."),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))],
          ),
        );
      } else {
        _showSnack("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      // 🟢 DEBUG 4: Catch the Timeout/Network error
      print("🚨 CONNECTION FAILURE: $e");
      _showSnack("Connection Timed Out. Check Laptop IP and Firewall.");
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // 🟢 Extract the lists sent from the dashboardData
    List<dynamic> allReports = widget.data['reports'] ?? [];
    List<dynamic> alertList = widget.data['diseases_to_alert'] ?? []; // Diseases with 3+ cases
    List<dynamic> sentList = widget.data['sent_alerts'] ?? [];       // Diseases already notified in DB

    DateTime now = DateTime.now();
    List<dynamic> newReports = allReports.where((r) {
      DateTime reportDate = DateTime.parse(r['created_at']).toLocal();
      return now.difference(reportDate).inHours <= 48;
    }).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Resident Reports"),
          bottom: const TabBar(
            indicatorColor: Color(0xFF30B1D2),
            labelColor: Color(0xFF30B1D2),
            tabs: [Tab(text: "All Reports"), Tab(text: "New (Last 48h)")],
          ),
        ),
        body: TabBarView(
          children: [
            // 🟢 Pass the alertList AND the sentList to the builder
            _buildList(allReports, alertList, sentList),
            _buildList(newReports, alertList, sentList),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<dynamic> list, List<dynamic> alertList, List<dynamic> sentList) {
    if (list.isEmpty) return const Center(child: Text("No reports found."));

    // 1. Normalize the alert list (3+ cases)
    List<String> normalizedAlertList = alertList.map((e) =>
        e.toString().toLowerCase().trim()).toList();

    // 2. Normalize the sent list (Already notified in DB)
    List<String> normalizedSentList = sentList.map((e) =>
        e.toString().toLowerCase().trim()).toList();

    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (ctx, i) {
        final r = list[i];
        String rawName = (r['predicted_disease'] ?? "Unknown");
        String diseaseNameOnCard = rawName.toLowerCase().trim();

        // 🟢 Logic 1: Is this an outbreak (3+ cases)?
        bool isOutbreak = normalizedAlertList.contains(diseaseNameOnCard);

        // 🟢 Logic 2: Is it already sent?
        // (Checks either the current session 'sentAlerts' OR the Database 'normalizedSentList')
        bool alreadySent = sentAlerts.contains(diseaseNameOnCard) ||
            normalizedSentList.contains(diseaseNameOnCard);

        DateTime dt = DateTime.parse(r['created_at']).toLocal();
        String timeStr = "${dt.hour % 12 == 0 ? 12 : dt.hour % 12}:${dt.minute
            .toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}";
        String dateStr = "${dt.day.toString().padLeft(2, '0')}/${dt.month
            .toString().padLeft(2, '0')}/${dt.year}";

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color: isOutbreak ? Colors.red.shade400 : Colors.grey.shade200,
                width: isOutbreak ? 2 : 1
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            title: Text(rawName.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold,
                    color: isOutbreak ? Colors.red : Colors.black87)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text("Reported: $dateStr at $timeStr"),
                Text(
                  isOutbreak
                      ? (alreadySent
                      ? "Status: ALERTED ✅"
                      : "Status: 🚨 OUTBREAK DETECTED")
                      : "Status: Monitoring",
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isOutbreak ? (alreadySent ? Colors.green : Colors
                          .red) : Colors.orange.shade700
                  ),
                ),
              ],
            ),
            trailing: isOutbreak
                ? (alreadySent
                ? const Text("SENT ✅", style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold))
                : ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => _triggerClusterAlert(context, rawName),
              child: const Text("ALERT ALL",
                  style: TextStyle(color: Colors.white, fontSize: 10)),
            ))
                : const Icon(
                Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(
                    builder: (c) => ReportDetailsScreen(report: r))),
          ),
        );
      },
    );
  }}