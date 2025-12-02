/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  String loginMessage = '';

  Future<void> login() async {
    final url = Uri.parse('http://10.225.230.158:8000/api/userauth/login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username_or_email": userController.text.trim(),
        "password": passController.text,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HaiPage()),
      );
    } else {
      setState(() {
        loginMessage = "Invalid credentials";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: userController,
              decoration: InputDecoration(labelText: "Username or Email"),
            ),
            TextField(
              controller: passController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text("Login"),
            ),
            SizedBox(height: 20),
            Text(
              loginMessage,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'signup.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  String loginMessage = '';
  bool showPassword = false;

  Future<void> login() async {
    final url = Uri.parse('http://localhost:8080/api/userauth/login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username_or_email": userController.text.trim(),
        "password": passController.text,
      }),
    );
    if (response.statusCode == 200) {
      print("Hai"); // ONLY print to console
      setState(() {
        loginMessage = 'login sucessfull'; // Clear error on success
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      // Optionally, do navigation here
    } else {
      setState(() {
        loginMessage = "Invalid credentials";
      });
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
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "MediSense",
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xFF22B7E9),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Log In",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 28),
                // Email field
                TextField(
                  controller: userController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Color(0xFF22B7E9)),
                    labelText: "Email Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFF22B7E9),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFF22B7E9),
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => clearLoginMessage(),
                ),
                SizedBox(height: 16),

                // Password field with show/hide
                TextField(
                  controller: passController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF22B7E9)),
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFF22B7E9),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFF22B7E9),
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !showPassword,
                  onChanged: (value) => clearLoginMessage(),
                ),
                SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF22B7E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (loginMessage.isNotEmpty) ...[
                  SizedBox(height: 10),
                  Text(
                    loginMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],

                SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Or", style: TextStyle(color: Colors.grey[700])),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
                  ],
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                    InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't Have an Account?",
                        style: TextStyle(color: Colors.grey[700], fontSize: 15)),
                    SizedBox(width: 4),

                    GestureDetector(
                      onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpPage()),
                          );
                        // Navigate to Sign Up
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Color(0xFF22B7E9),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),     //18
                SizedBox(height: 27), //24
              ],
            ),
          ),
        ),
      ),
    );
  }
}
