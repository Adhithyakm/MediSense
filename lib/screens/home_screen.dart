import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'report_symptoms_screen.dart';
import 'report_risk_screen.dart';
import 'econsultation_screen.dart';
import 'map_screen.dart';
import 'tasks_screen.dart';
import 'profile_screen.dart';
import 'notifications_page.dart';
import 'login_screen.dart';
import 'select_city_screen.dart'; // Import this so we can navigate back if needed
import '../services/locationservices.dart';

// ====================================================================
// DATA MODEL
// ====================================================================
class UserProfile {
  final String fullName;
  final String email;
  final String mobile;

  UserProfile({
    required this.fullName,
    required this.email,
    required this.mobile,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    String name = json['full_name'] ?? "Guest User";
    return UserProfile(
      fullName: name.isEmpty ? "Guest User" : name,
      email: json['email'] ?? "No Email Provided",
      mobile: json['mobile_number'] ?? "",
    );
  }
}

// ====================================================================
// STATE MANAGEMENT (UserProvider)
// ====================================================================
class UserProvider with ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Make sure this IP matches your SelectCityScreen IP!
      final url = Uri.parse("http://192.168.24.71:8080/api/accounts/profile/");
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _userProfile = UserProfile.fromJson(data);
      } else {
        _userProfile = null;
        print("Failed to load profile: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearUserProfile() {
    _userProfile = null;
    notifyListeners();
  }
}

// ====================================================================
// HOME SCREEN
// ====================================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const MapScreen(),
    TasksScreen(),
    const SetupProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserProfile();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF30B1D2),
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}

// ====================================================================
// HOME CONTENT (UPDATED LOGIC HERE)
// ====================================================================
class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? city;

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  // --- UPDATED LOCATION LOGIC ---
  void loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 1. Try to get the Manual Selection (from SelectCityScreen)
    String? manualLocalBody = prefs.getString('selectedLocalBody');
    String? manualDistrict = prefs.getString('selectedDistrict');

    if (manualLocalBody != null && manualDistrict != null) {
      // If user selected a city manually, show that!
      setState(() {
        city = "$manualLocalBody, $manualDistrict";
      });
    } else {
      // 2. If no manual selection, try Auto-Detect (GPS)
      String? detectedCity = await getDetectedLocality();
      setState(() {
        city = detectedCity ?? "Unknown Location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final displayFullName = userProvider.userProfile?.fullName ?? "User";

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // LOCATION DROPDOWN
                  GestureDetector(
                    // Allow clicking to change city manually again
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const SelectCityScreen(),
                      ));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF30B1D2), size: 24),
                        const SizedBox(width: 8),
                        Text(
                          // Show the loaded city name here
                          city != null && city!.length > 25
                              ? "${city!.substring(0, 22)}..." // Truncate if too long
                              : "${city ?? 'Detecting...'} ▼",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87
                          ),
                        ),
                      ],
                    ),
                  ),

                  // NOTIFICATION ICON
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                      ));
                    },
                    child: const Icon(Icons.notifications_outlined, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Greeting
              Text(
                "Welcome $displayFullName!",
                style: const TextStyle(
                  color: Color(0xFF30B1D2),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "How is it going today?",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 30),

              // --- BUTTON 1: REPORT SYMPTOMS ---
              OptionButton(
                icon: Icons.add_circle_outline,
                label: "Report Symptoms",
                onTap: () {
                  // Pass the loaded city to the Symptoms Screen
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ReportSymptomsScreen(
                      selectedCity: city ?? "Locating...",
                    ),
                  ));
                },
              ),

              const SizedBox(height: 20),

              // --- BUTTON 2: REPORT RISK ---
              OptionButton(
                icon: Icons.warning_amber_rounded,
                label: "Report A Community Risk",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ReportRiskScreen(
                      selectedCity: city ?? "Locating...",
                    ),));
                },
              ),

              const SizedBox(height: 20),

              // --- BUTTON 3: CONSULTATION ---
              OptionButton(
                icon: Icons.medication_outlined,
                label: "Feedback",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const EConsultationScreen(),
                  ));
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// OPTION BUTTON
// ====================================================================
class OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const OptionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
            color: const Color(0xFF30B1D2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5)
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// APP DRAWER
// ====================================================================
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final fullName = userProvider.userProfile?.fullName ?? 'Welcome User!';
    final email = userProvider.userProfile?.email ?? 'user.email@example.com';
    final isLoading = userProvider.isLoading;

    void navigateAndClose(Widget screen) {
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => screen));
    }

    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF30B1D2),
            child: SafeArea(
              child: isLoading
                  ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
                  : Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 35),
                    backgroundColor: Colors.white70,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Drawer Navigation Items
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Map'),
            onTap: () => navigateAndClose(const MapScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('My Reports'),
            onTap: () => navigateAndClose(TasksScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () => navigateAndClose(const SetupProfileScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.medical_services_outlined),
            title: const Text('Feedback'),
            onTap: () => navigateAndClose(const EConsultationScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                // Log out
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                userProvider.clearUserProfile();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF30B1D2),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}