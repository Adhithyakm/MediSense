import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'outbreak_map_screen.dart';

// Ensure these files exist in your project
import 'resident_reports_screen.dart';
import 'risk_alert_screen.dart';
import 'health_login.dart';

class OfficialDashboardScreen extends StatefulWidget {
  const OfficialDashboardScreen({super.key});

  @override
  State<OfficialDashboardScreen> createState() => _OfficialDashboardScreenState();
}

class _OfficialDashboardScreenState extends State<OfficialDashboardScreen> {
  Map<String, dynamic> dashboardData = {};
  bool isLoading = true;
  int _selectedIndex = 0; // For Bottom Navigation

  // 🟢 UPDATE THIS IP to match your laptop's current IP
  final String baseUrl = "http://192.168.24.71:8080/api/reports_api";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      _logout();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get-dashboard/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          dashboardData = jsonDecode(response.body);
          isLoading = false;
        });
        print("🔥 Dashboard Data Loaded. Outbreaks: ${dashboardData['diseases_to_alert']}");
      }
    } catch (e) {
      print("Error fetching dashboard: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  // 🟢 Cumulative Symptom Logic: Adds up total count (3+2=5)
  int _calculateCumulativeSymptoms(List<dynamic> reports) {
    int total = 0;
    for (var report in reports) {
      String symptoms = report['symptoms_list'] ?? "";
      if (symptoms.isNotEmpty) {
        List<String> list = symptoms.split(',').where((s) => s.trim().isNotEmpty).toList();
        total += list.length;
      }
    }
    return total;
  }
  // 🟢 1. ADD THIS: Function to tell the server the official has seen the reports
  Future<void> _resetReportCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/clear-report-count/'), // Ensure this matches your urls.py
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        _fetchData(); // Refresh the UI so the top box becomes 0
      }
    } catch (e) {
      print("Error resetting count: $e");
    }
  }
  Future<void> _logout() async {
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
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF30B1D2))));
    }

    // Extract Data
    List<dynamic> reports = dashboardData['reports'] ?? [];
    List<dynamic> risks = dashboardData['risks'] ?? [];
    List<dynamic> alerts = dashboardData['priority_alerts'] ?? [];
    String jurisdiction = (dashboardData['jurisdiction'] ?? "Jurisdiction").split(',')[0];

    // Logic
    int symptomCount = _calculateCumulativeSymptoms(reports);
    int riskCount = risks.length;
    List<dynamic> priorityAlerts = alerts.where((a) => (a['case_count'] ?? 0) >= 2).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: Row(
          children: [
            Text(jurisdiction, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            const Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: _fetchData),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome Sir!",
                  style: TextStyle(color: Color(0xFF30B1D2), fontSize: 20, fontWeight: FontWeight.bold)),
              const Text("Here is the update for your zone.",
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 25),

              // --- SUMMARY BOXES ---
              Row(
                children: [
                  _buildSummaryBox(
                    label: "New Reports",
                    count: symptomCount.toString(),
                    icon: Icons.add_circle,
                    color: Colors.blue,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ResidentListScreen(data: dashboardData))),
                  ),
                  const SizedBox(width: 15),
                  _buildSummaryBox(
                    label: "New Risk Alerts",
                    count: riskCount.toString(),
                    icon: Icons.warning_amber_rounded,
                    color: Colors.orange,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => RiskAlertsScreen(risks: risks))),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- ACTION BUTTONS ---
              _buildActionBtn("View Regional Outbreak Map", true, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => OutbreakMapScreen(
                      alerts: dashboardData['district_map_hotspots'] ?? [], // 🟢 Use this key
                      district: dashboardData['district'] ?? "District",
                    )));
              }),
              const SizedBox(height: 12),
              _buildActionBtn("Analyze Reports", false, onTap: () async {
                await _resetReportCount();
                print("Alert List: ${dashboardData['diseases_to_alert']}");
                Navigator.push(context, MaterialPageRoute(builder: (c) => ResidentListScreen(data: dashboardData)));
              }),

              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Priority Alerts (2+ Cases)",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  TextButton(onPressed: () {}, child: const Text("See All", style: TextStyle(color: Color(0xFF30B1D2)))),
                ],
              ),
              const SizedBox(height: 10),

              // --- ALERT LIST ---
              priorityAlerts.isEmpty
                  ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No outbreaks detected.", style: TextStyle(color: Colors.grey))))
                  : Column(
                children: priorityAlerts.map((alert) => _buildPriorityCard(alert)).toList(),
              ),
            ],
          ),
        ),
      ),

      // 🟢 ADDED: BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF30B1D2),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 3) _logout(); // Optional: Logout if last tab clicked
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  // --- UI WIDGETS ---

  Widget _buildSummaryBox({required String label, required String count, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.15)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 12),
              Text(count, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionBtn(String label, bool filled, {required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: filled ? const Color(0xFF30B1D2) : Colors.white,
            side: filled ? null : const BorderSide(color: Color(0xFF30B1D2), width: 1.5),
            elevation: filled ? 2 : 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
        ),
        child: Text(label, style: TextStyle(color: filled ? Colors.white : const Color(0xFF30B1D2), fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
  Future<void> _triggerCommunityAlert(String diseaseName) async {
    // Show a loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sending $diseaseName alert to all residents...")),
    );

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse("$baseUrl/trigger-community-alert/"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({"disease": diseaseName}),
      );

      if (response.statusCode == 200) {
        // 🟢 REFRESH THE DATA: This makes the button turn into "SENT ✅"
        _fetchData();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Success! Alert broadcasted to the Panchayat."),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      print("Error triggering alert: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to send alert. Check your connection."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Widget _buildPriorityCard(Map<String, dynamic> alert) {
    // 🟢 1. Check if the alert was already sent (this comes from the is_notified field)
    bool alreadySent = alert['is_notified'] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // Border turns Green if sent, Red if not
        side: BorderSide(color: alreadySent ? Colors.green : Colors.red, width: 1.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: alreadySent ? Colors.green[50] : const Color(0xFFFFEBEE),
          child: Icon(
              alreadySent ? Icons.check_circle : Icons.gpp_maybe,
              color: alreadySent ? Colors.green : Colors.red
          ),
        ),
        title: Text("${alert['disease'].toString().toUpperCase()} Outbreak",
            style: TextStyle(
                color: alreadySent ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold
            )),
        subtitle: Text("${alert['case_count']} clusters identified."),

        // 🟢 2. THE UI LOGIC: If sent, show "SENT". If not, show the Button.
        trailing: alreadySent
            ? const Text("SENT ✅",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
            : ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => _triggerCommunityAlert(alert['disease']),
          child: const Text("SEND", style: TextStyle(color: Colors.white, fontSize: 11)),
        ),
      ),
    );
  }
}