import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // 🟢 ADDED

import 'login_screen.dart';
import 'profile_screen.dart';

class SignUpPage extends StatefulWidget {
 @override
 _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
 final TextEditingController fullNameController = TextEditingController();
 final TextEditingController mobileController = TextEditingController();
 final TextEditingController emailController = TextEditingController();
 final TextEditingController passwordController = TextEditingController();

 String message = '';
 bool acceptedTerms = false;
 bool showPassword = false;
 bool isLoading = false;

 Future<void> signUp() async {
  if (!acceptedTerms) {
   setState(() => message = "Please accept Terms & Conditions.");
   return;
  }

  setState(() {
   isLoading = true;
   message = '';
  });

  try {
   // 🟢 GET ANONYMOUS DEVICE TOKEN
   String? fcmToken = await FirebaseMessaging.instance.getToken();

   final url = Uri.parse('http://192.168.24.71:8080/api/accounts/register/');

   final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
     "full_name": fullNameController.text.trim(),
     "mobile_number": mobileController.text.trim(),
     "email": emailController.text.trim(),
     "password": passwordController.text,
     "fcm_token": fcmToken, // 🟢 SENT TO BACKEND
    }),
   );

   if (response.statusCode == 201) {
    var data = jsonDecode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save Token for future API calls
    if (data['token'] != null) {
     await prefs.setString('token', data['token']);
    }

    setState(() => message = "Sign up successful!");
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SetupProfileScreen()),
     );
    }
   } else {
    setState(() => message = "Error: Registration failed.");
   }
  } catch (e) {
   setState(() => message = "Network Error: $e");
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
        _buildTextField(fullNameController, "Full Name", Icons.person),
        const SizedBox(height: 16),
        _buildTextField(mobileController, "Mobile Number", Icons.phone, inputType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField(emailController, "Email Address", Icons.email, inputType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        TextField(
         controller: passwordController,
         obscureText: !showPassword,
         decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF22B7E9)),
          labelText: "Password",
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
           icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: const Color(0xFF22B7E9)),
           onPressed: () => setState(() => showPassword = !showPassword),
          ),
         ),
        ),
        const SizedBox(height: 10),
        Row(
         children: [
          Checkbox(value: acceptedTerms, activeColor: const Color(0xFF22B7E9), onChanged: (val) => setState(() => acceptedTerms = val ?? false)),
          const Expanded(child: Text("Accept Terms & Conditions", style: TextStyle(fontSize: 13))),
         ],
        ),
        const SizedBox(height: 15),
        SizedBox(
         width: double.infinity,
         height: 48,
         child: ElevatedButton(
          onPressed: isLoading ? null : signUp,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22B7E9)),
          child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Sign Up", style: TextStyle(color: Colors.white)),
         ),
        ),
        if (message.isNotEmpty) Text(message, style: const TextStyle(color: Colors.red)),
       ],
      ),
     ),
    ),
   ),
  );
 }

 Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType inputType = TextInputType.text}) {
  return TextField(
   controller: controller,
   keyboardType: inputType,
   decoration: InputDecoration(
    prefixIcon: Icon(icon, color: const Color(0xFF22B7E9)),
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
   ),
  );
 }
}