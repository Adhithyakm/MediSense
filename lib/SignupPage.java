import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  String _errorMessage = '';

  Future<void> signup() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/accounts/register/'); // Use 10.0.2.2 for Android emulator
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": _usernameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
        "password2": _confirmController.text,
      }),
    );
    if (response.statusCode == 201) {
      setState(() {
        _errorMessage = "Registration successful!";
      });
      // Navigate to login page or home page
    } else {
      setState(() {
        _errorMessage = "Registration failed: ${response.body}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Sign Up')),
        body: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: _confirmController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: signup,
                  child: Text('Sign Up'),
                ),
                SizedBox(height: 12),
                Text(_errorMessage, style: TextStyle(color: Colors.red)),
              ],
            )));
  }
}
