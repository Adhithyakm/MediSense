import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'select_city_screen.dart';
//import 'home_screen.dart';

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

    final url = Uri.parse('http://10.69.161.158:8080/api/userauth/login/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username_or_email": userController.text.trim(),
          "password": passController.text,
        }),
      );

      print("Login response: ${response.body}"); // Debug backend response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ TOKEN FIX: Correctly using the 'token' key
        final token = data['token']?.toString();

        if (token != null && token.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          setState(() {
            loginMessage = 'Login successful';
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SelectCityScreen()),
          );
        } else {
          setState(() {
            loginMessage = "Login failed: Token not received";
          });
        }
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          loginMessage = errorData['detail']?.toString() ?? "Invalid credentials";
        });
      }
    } catch (e) {
      setState(() {
        loginMessage = "Error connecting to server: $e";
      });
    } finally {
      setState(() => isLoading = false);
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
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "MediSense",
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xFF22B7E9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Log In",
                  style: TextStyle(
                      fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 28),

                TextField(
                  controller: userController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Color(0xFF22B7E9)),
                    labelText: "Email Address",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => clearLoginMessage(),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: passController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF22B7E9)),
                    labelText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
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
                      "Sign In",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (loginMessage.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    loginMessage,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],

                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't Have an Account?",
                        style: TextStyle(color: Colors.grey[700], fontSize: 15)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          // 🚨 FINAL FIX: REMOVED 'const' from SignUpPage()
                          // because SignUpPage is a StatefulWidget and cannot be const.
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Color(0xFF22B7E9),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}