import 'package:flutter/material.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF61BEEA), Color(0xFF38A4D7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'lib/assets/logo.png',
                height: 60,
              ),
              SizedBox(height: 8),//8
              Text(
                'Medisense',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Who Are You?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 220,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    // TODO: Add navigation for Health Official
                  },
                  child: Text('Health Official', style: TextStyle(color: Color(0xFF38A4D7))),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 220,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()), // Use your login page widget
                    );
                  },
                  child: Text('Resident', style: TextStyle(color: Color(0xFF38A4D7))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
