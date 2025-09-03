import 'package:flutter/material.dart';
import 'screens/medisensescreen.dart'; // This should exist as shown above
import 'screens/roleselection_screen.dart';
void main() {
  runApp(MediSenseApp());
}

class MediSenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediSense',
      debugShowCheckedModeBanner: false,
      home: SplashRoute(), // Refers to the class inside medisensescreen.dart
    );
  }
}
class SplashRoute extends StatefulWidget {
  @override
  _SplashRouteState createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

