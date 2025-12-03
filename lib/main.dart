/*import 'package:flutter/material.dart';
import 'screens/medisensescreen.dart';
import 'screens/home_screen.dart';
void main() {
  runApp(const MediSenseApp());
}

class MediSenseApp extends StatelessWidget {
  const MediSenseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),


    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Required for State Management

// Import your screens
import 'screens/medisensescreen.dart'; // Ensure this file contains class SplashScreen
import 'screens/home_screen.dart';     // Ensure this file contains class UserProvider

void main() {
  runApp(
    // 🛑 WRAPPING THE APP WITH PROVIDER
    ChangeNotifierProvider(
      create: (context) => UserProvider(), // This initializes the global state
      child: const MediSenseApp(),
    ),
  );
}

class MediSenseApp extends StatelessWidget {
  const MediSenseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // 🛑 ENSURE THIS MATCHES THE CLASS NAME IN medisensescreen.dart
      home: SplashScreen(),
    );
  }
}