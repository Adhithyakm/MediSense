import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'official_dashboard_screen.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreens> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  String loginMessage = '';
  bool showPassword = false;
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      loginMessage = '';
    });

    // 🟢 FIXED: Added your IP Address here
    final url = Uri.parse('http://192.168.24.71:8080/api/accounts/login/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": userController.text.trim(),
          "password": passController.text,
        }),
      );

      print("Login response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data['token']?.toString();
        // 🟢 Robust Logic: Handle potential nulls safely
        String rawRole = data['role']?.toString() ?? "";

        // 🟢 CRITICAL FIX: Remove spaces and force lowercase
        String role = rawRole.trim().toLowerCase();

        print("🔍 DEBUG: Server sent role: '$rawRole' -> We checked: '$role'");

        if (token != null && token.isNotEmpty) {

          // 🛑 SECURITY CHECK: Only allow 'official' role
          if (role != 'official') {
            setState(() {
              // Show the actual role received to help debug
              loginMessage = "Access Denied. Your role is '$role', not 'official'.";
              isLoading = false;
            });
            return;
          }

          // ✅ Save Token & Role
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('role', role);

          setState(() {
            loginMessage = 'Login successful';
          });

          // ✅ Navigate to Official Dashboard
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OfficialDashboardScreen()),
            );
          }
        } else {
          setState(() {
            loginMessage = "Login failed: Token not received";
          });
        }
      } else {
        final errorData = jsonDecode(response.body);
        String errorMsg = "Invalid credentials";
        if (errorData['non_field_errors'] != null) {
          errorMsg = errorData['non_field_errors'][0];
        }
        setState(() {
          loginMessage = errorMsg;
        });
      }
    } catch (e) {
      setState(() {
        loginMessage = "Error connecting to server. Check internet.";
      });
      print("Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void clearLoginMessage() {
    if (loginMessage.isNotEmpty) {
      setState(() {
        loginMessage = '';
      });
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
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.local_hospital, size: 50, color: Color(0xFF22B7E9)),
                const SizedBox(height: 10),
                const Text(
                  "MediSense Admin",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF22B7E9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Official Login",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 28),

                TextField(
                  controller: userController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Color(0xFF22B7E9)),
                    labelText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF22B7E9), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => clearLoginMessage(),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: passController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF22B7E9)),
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF22B7E9), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) => clearLoginMessage(),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22B7E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Access Dashboard",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (loginMessage.isNotEmpty) ...[
                  const SizedBox(height: 15),
                  Text(
                    loginMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],

                const SizedBox(height: 20),

                const Text(
                  "Restricted Access for Authorized Officials Only.",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}