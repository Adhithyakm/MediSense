import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'signup.dart';
import 'home_screen.dart';
import 'official_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  String loginMessage = '';
  bool showPassword = false;
  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);

    try {
      // 🟢 1. REQUEST PERMISSION (Specifically for Android 13+)
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true,
      );

      // 🟢 2. GET THE ANONYMOUS DEVICE TOKEN
      String? fcmToken = await messaging.getToken();
      print("🚀 DEVICE TOKEN: $fcmToken"); // Copy this from console to test manually!

      final url = Uri.parse('http://192.168.24.71:8080/api/accounts/login/');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": userController.text.trim(),
          "password": passController.text,
          "fcm_token": fcmToken, // 🟢 SENDS TOKEN TO DJANGO
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final role = data['role'];

        if (token != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('role', role);

          if (role == 'official') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const OfficialDashboardScreen()));
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
          }
        }
      } else {
        setState(() => loginMessage = "Invalid credentials");
      }
    } catch (e) {
      setState(() => loginMessage = "Connection Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                const Text("MediSense", style: TextStyle(fontSize: 32, color: Color(0xFF22B7E9), fontWeight: FontWeight.bold)),
                const SizedBox(height: 28),
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.email, color: Color(0xFF22B7E9)), labelText: "Email/Username", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF22B7E9)),
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => showPassword = !showPassword)),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22B7E9)),
                    child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Sign In", style: TextStyle(color: Colors.white)),
                  ),
                ),
                if (loginMessage.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10), child: Text(loginMessage, style: const TextStyle(color: Colors.red))),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => SignUpPage())),
                  child: const Text("Sign Up", style: TextStyle(color: Color(0xFF22B7E9), fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}