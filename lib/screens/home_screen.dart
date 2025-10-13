import 'package:flutter/material.dart';
import 'report_symptoms_screen.dart';
import 'report_risk_screen.dart'; // Assuming this is ReportCommunityRiskScreen
import 'econsultation_screen.dart';
import 'map_screen.dart';
import 'tasks_screen.dart';
import 'profile_screen.dart'; // Assuming this is SetupProfileScreen

class HomeScreen extends StatefulWidget {
  final String fullName;

  const HomeScreen({Key? key, required this.fullName}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(fullName: widget.fullName),
      const MapScreen(),
      const TasksScreen(),
      // Ensure SetupProfileScreen can take fullName if needed, or remove if not
      SetupProfileScreen(fullName: widget.fullName), // Added fullName
    ];
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF30B1D2),
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String fullName;

  const HomeContent({Key? key, required this.fullName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.menu, size: 28),
                    SizedBox(width: 8),
                    Text(
                      "Palakkad ▼",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const Icon(Icons.notifications_outlined, size: 26),
              ],
            ),
            const SizedBox(height: 20),

            // Greeting
            Text( // Removed 'const' because of string interpolation
              "Welcome $fullName!",
              style: const TextStyle( // Make TextStyle const if possible
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

            // Buttons
            OptionButton(
              icon: Icons.add_circle_outline,
              label: "Report Symptoms",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportSymptomsScreen(fullName: fullName)),
                );
                // Removed the extra closing parenthesis here, which was causing syntax errors.
              },
            ),
            const SizedBox(height: 20),
            OptionButton(
              icon: Icons.warning_amber_rounded,
              label: "Report A Community Risk",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportCommunityRiskScreen(fullName: fullName)),
                );
              },
            ),
            const SizedBox(height: 20),
            OptionButton(
              icon: Icons.medication_outlined,
              label: "eConsultation",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EConsultationScreen(fullName: fullName)), // fullName is now passed
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

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