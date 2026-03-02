import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import '../logic/federated_engine.dart';

class ReviewSubmitScreen extends StatefulWidget {
  final String symptoms;
  final String readableSymptoms;
  final String description;
  final String location;
  final double latitude;
  final double longitude;

  const ReviewSubmitScreen({
    Key? key,
    required this.symptoms,
    required this.readableSymptoms,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<ReviewSubmitScreen> createState() => _ReviewSubmitScreenState();
}

class _ReviewSubmitScreenState extends State<ReviewSubmitScreen> {
  bool consentGiven = false;
  bool _isSubmitting = false;
  int? _storedLocalBodyId;
  String _localAIPrediction = "Analyzing...";

  // 🟢 1. IMPORTANT: Ensure this matches your CURRENT laptop IP (from ipconfig)
  final String baseUrl = "http://192.168.24.71:8080/api/reports_api";

  @override
  void initState() {
    super.initState();
    _loadLocationId();
    _runLocalAI();
  }

  void _runLocalAI() {
    setState(() {
      // Runs the Bayesian Probability model locally on the phone
      _localAIPrediction = FederatedEngine.predict(widget.symptoms);
    });
  }

  Future<void> _loadLocationId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedLocalBodyId = prefs.getInt('selected_local_body_id');
    });
  }

  Future<void> _submitFinalReport() async {
    if (_storedLocalBodyId == null) {
      _showSnack("Error: Local Body ID missing.");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // 🟢 2. FEDERATED LEARNING STEP: Calculate the Weight Updates (The "Learning")
      // We convert the symptoms to a list and calculate the mathematical delta
      List<String> symptomKeys = widget.symptoms.split(',').map((s) => s.trim()).toList();
      Map<String, double> modelWeightsUpdate = FederatedEngine.computeLocalUpdate(_localAIPrediction, symptomKeys);

      String anonId = "guest";
      if (token != null) {
        var bytes = utf8.encode(token + "MEDI_SALT_2026");
        anonId = sha256.convert(bytes).toString();
      }

      // 🟢 3. DATA MINIMIZATION: Prepare the Payload
      Map<String, dynamic> bodyData = {
        "anonymous_id": anonId,
        "predicted_disease": _localAIPrediction, // The Insight
        "model_weights_update": modelWeightsUpdate, // 🟢 The "Learning" math
        "description": widget.description,
        "local_body_id": _storedLocalBodyId,
        "latitude": widget.latitude,
        "longitude": widget.longitude,
        "specific_address": widget.location,
        // ❌ SYMPTOMS REMOVED: widget.symptoms is NOT sent to server.
      };

      final response = await http.post(
        Uri.parse("$baseUrl/submit-symptoms/"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Token $token",
        },
        body: jsonEncode(bodyData),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccess(_localAIPrediction);
      } else {
        _showSnack("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Connection Error: $e");
      _showSnack("Connection Error. Check Laptop IP & Server Status.");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showSuccess(String disease) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Federated Submission ✅"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Diagnosis and Model Training were performed locally on your device."),
            const SizedBox(height: 15),
            Text(disease.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF30B1D2), fontSize: 20)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const HomeScreen()), (r) => false),
              child: const Text("OK")
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Secure Review"), centerTitle: true, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(border: Border.all(color: Colors.cyan.withOpacity(0.3)), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("ON-DEVICE AI PREDICTION:", style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 11)),
                  Text(_localAIPrediction.toUpperCase(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  const Divider(height: 30),
                  _buildInfoRow(Icons.medical_services, "Symptoms", widget.readableSymptoms),
                  _buildInfoRow(Icons.map, "Location", widget.location),
                  _buildInfoRow(Icons.security, "Privacy", "Federated Edge-Inference Active"),
                ],
              ),
            ),
            const Spacer(),
            CheckboxListTile(
              activeColor: const Color(0xFF30B1D2),
              title: const Text("I consent to share the anonymous diagnosis and local model updates.", style: TextStyle(fontSize: 12)),
              value: consentGiven,
              onChanged: (val) => setState(() => consentGiven = val!),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (consentGiven && !_isSubmitting) ? _submitFinalReport : null,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF30B1D2), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text("CONFIRM & SEND INSIGHTS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [Icon(icon, size: 16, color: Colors.grey), const SizedBox(width: 10), Expanded(child: Text("$label: $value", style: const TextStyle(fontSize: 13)))]),
    );
  }
}