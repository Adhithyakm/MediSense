/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';


class SignUpPage extends StatefulWidget {
@override
 _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
 final TextEditingController usernameController = TextEditingController();
 final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmController = TextEditingController();

String message = '';

Future<void> signUp() async {
final url = Uri.parse('http://10.225.230.158:8000/api/accounts/register/');
final response = await http.post(
url,
headers: {'Content-Type': 'application/json'},
body: jsonEncode({
 "username": usernameController.text.trim(), // add this controller and field in UI
 "email": emailController.text.trim(),
 "password": passwordController.text,
 "password2": confirmController.text,
}),
);

if (response.statusCode == 201) {
setState(() {
message = "Sign up successful!";
});
// Optionally, clear fields or navigate to login
// Navigator.pushReplacementNamed(context, '/login');
} else {
final errorResponse = jsonDecode(response.body);
setState(() {
message = "Error: ${errorResponse.toString()}";
});
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text("Sign Up")),
body: Padding(
padding: EdgeInsets.all(20),
child: Column(
children: [
 TextField(
  controller: usernameController,
  decoration: InputDecoration(labelText: "Username"),
 ),

 TextField(
controller: emailController,
decoration: InputDecoration(labelText: "Email"),
keyboardType: TextInputType.emailAddress,
),
TextField(
controller: passwordController,
decoration: InputDecoration(labelText: "Password"),
obscureText: true,
),
TextField(
controller: confirmController,
decoration: InputDecoration(labelText: "Confirm Password"),
obscureText: true,
),

SizedBox(height: 20),
ElevatedButton(onPressed: signUp, child: Text("Register")),
SizedBox(height: 20),
Text(
message,
style: TextStyle(
color: message == "Sign up successful!" ? Colors.green : Colors.red,
fontWeight: FontWeight.bold,
),
),
 TextButton(
  onPressed: () {
   Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()), // refer to login page below
   );
  },
  child: Text("Already have an account? Login"),
 ),
],
)));
}
}*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';
import 'home_screen.dart';

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

 Future<void> signUp() async {
  if (!acceptedTerms) {
   setState(() {
    message = "Please accept Terms & Conditions.";
   });
   return;
  }
  final url = Uri.parse('http://10.69.161.158:8080/api/accounts/register/');
  final response = await http.post(
   url,
   headers: {'Content-Type': 'application/json'},
   body: jsonEncode({
    "full_name": fullNameController.text.trim(),
    "mobile_number": mobileController.text.trim(),
    "email": emailController.text.trim(),
    "password": passwordController.text,
   }),
  );

  if (response.statusCode == 201) {
   setState(() {
    message = "Sign up successful!";
   });

   // Optionally, clear fields or navigate to login
   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  } else {
   String errMsg = "Registration failed.";
   try {
    var errorResponse = jsonDecode(response.body);
    errMsg = errorResponse.toString();
   } catch (_) {}
   setState(() {
    message = "Error: $errMsg";
   });
  }
 }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   // Remove appBar for a cleaner card look, as per your design
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
         "Sign Up",
         style: TextStyle(
             fontSize: 24,
             color: Colors.black,
             fontWeight: FontWeight.bold
         ),
        ),
        SizedBox(height: 28),

        // Full Name
        TextField(
         controller: fullNameController,
         decoration: InputDecoration(
          prefixIcon: Icon(Icons.person, color: Color(0xFF22B7E9)),
          labelText: "Full Name",
          border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(8),
           borderSide: BorderSide(
            color: Color(0xFF22B7E9),
            width: 2,
           ),
          ),
         ),
        ),
        SizedBox(height: 16),
        // Mobile Number
        TextField(
         controller: mobileController,
         decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone, color: Color(0xFF22B7E9)),
          labelText: "Mobile Number",
          border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(8),
           borderSide: BorderSide(
            color: Color(0xFF22B7E9),
            width: 2,
           ),
          ),
         ),
         keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16),
        // Email Address
        TextField(
         controller: emailController,
         decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, color: Color(0xFF22B7E9)),
          labelText: "Email Address",
          border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(8),
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
        ),
        SizedBox(height: 16),
        // Password
        TextField(
         controller: passwordController,
         obscureText: !showPassword,
         decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF22B7E9)),
          labelText: "Password",
          border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(8),
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
            color: Color(0xFF22B7E9),
           ),
           onPressed: () {
            setState(() {
             showPassword = !showPassword;
            });
           },
          ),
         ),
        ),
        SizedBox(height: 12),
        Row(
         children: [
          Checkbox(
           value: acceptedTerms,
           activeColor: Color(0xFF22B7E9),
           onChanged: (bool? value) {
            setState(() {
             acceptedTerms = value ?? false;
            });
           },
          ),
          Expanded(
           child: Text(
            "I accept all the Terms & Conditions",
            style: TextStyle(
             fontSize: 13,
             fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
           ),
          ),
         ],
        ),
        SizedBox(height: 10),
        SizedBox(
         width: double.infinity,
         height: 48,
         child: ElevatedButton(
          onPressed: signUp,
          style: ElevatedButton.styleFrom(
           backgroundColor: Color(0xFF22B7E9),
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
           ),
          ),
          child: Text(
           "Sign Up", // You may want to call it "Sign Up" instead
           style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
           ),
          ),
         ),
        ),
        if (message.isNotEmpty) ...[
         SizedBox(height: 10),
         Text(
          message,
          style: TextStyle(
           color: message == "Sign up successful!" ? Colors.green : Colors.red,
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
          // Google icon
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
          // Facebook icon
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
          Text("Have an Account? ", style: TextStyle(color: Colors.grey[700], fontSize: 15)),
          GestureDetector(
           onTap: () {
            Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => LoginScreen()),
            );
           },
           child: Text(
            "Sign In",
            style: TextStyle(
                color: Color(0xFF22B7E9),
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
           ),
          ),
         ],
        ),
        SizedBox(height: 24), // Extra space at bottom
       ],
      ),
     ),
    ),
   ),
  );
 }
}


