import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'review_submit_screen.dart';

class ReportSymptomsScreen extends StatefulWidget {
  final String selectedCity;

  const ReportSymptomsScreen({Key? key, this.selectedCity = "Unknown Location"}) : super(key: key);

  @override
  State<ReportSymptomsScreen> createState() => _ReportSymptomsScreenState();
}

class _ReportSymptomsScreenState extends State<ReportSymptomsScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _otherSymptomController = TextEditingController();

  late String _currentLocation;
  double? _lat;
  double? _lng;
  bool _isFetchingLocation = false;
  final List<String> _selectedSymptoms = [];

  // Mapping "User Label" -> "Technical Column Header" for your CSV AI
  final Map<String, String> _symptomMapping = {
    'Very Dry Skin': 'very_dry_skin',
    'Slow Healing Sores': 'sores_that_heal_slowly',
    'Frequent Infections': 'more_infections_than_usual',
    'Nausea': 'nausea',
    'Stomach Pain': 'stomach_pains',
    'Frequent Urination': 'urinate_a_lot',
    'Excessive Thirst': 'feel_very_thirsty',
    // 🟢 FIXED: added 'ing'
    'Unexplained Weight Loss': 'lose_weight_without_trying',
    'Blurry Vision': 'blurry_vision',
    'Itching (Hands/Feet)': 'itching_hands_or_feet',
    'Extreme Hunger': 'feel_very_hungry',
    'Fever': 'fever',
    'Fatigue': 'fatigue',
    'Loss of Appetite': 'loss_of_appetite',
    'Vomiting': 'vomiting',
    'Abdominal Pain': 'abdominal_pain',
    'Dark Urine': 'dark_urine',
    'Pale/Light Stools': 'light_colored_stools',
    'Joint Pain': 'joint_pain',
    'Jaundice (Yellow Skin/Eyes)': 'jaundice',
    'Skin Rash': 'rash',
    'Bone Pain': 'bone_pain',
    'Muscle Pain': 'muscle_pain',
    'Cramps': 'cramp',
    'Pain Behind Eyes': 'eye_pain',
    // 🟢 FIXED: changed last underscore to a SPACE to match your matrix
    'Cough (Yellow/Green Mucus)': 'cough_with_yellow_or_green mucus',
    'Shortness of Breath': 'shortness_of_breath',
    'High Temperature': 'high_temperature',
    'Chest Pain': 'chest_pain',
    'Aching Body': 'aching_body',
    'Feeling Very Tired': 'feeling_very_tired',
    // 🟢 FIXED: changed 'breath' to 'breathe'
    'Wheezing': 'wheezing_noises_when_you_breathe',
    'Confusion': 'feeling_confused',
  };
  late final List<String> _availableSymptoms;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.selectedCity;
    _availableSymptoms = _symptomMapping.keys.toList()..add('Other');
  }

  Future<void> _fetchPreciseLocation() async {
    setState(() => _isFetchingLocation = true);
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        _lat = position.latitude;
        _lng = position.longitude;

        List<Placemark> placemarks = await placemarkFromCoordinates(_lat!, _lng!);
        if (placemarks.isNotEmpty) {
          Placemark p = placemarks[0];
          setState(() {
            _currentLocation = "${p.street}, ${p.subLocality}, ${p.locality}";
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("GPS Error. Using City default.")));
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  void _submitToReview() {
    List<String> techKeys = [];
    for (var label in _selectedSymptoms) {
      if (_symptomMapping.containsKey(label)) techKeys.add(_symptomMapping[label]!);
    }

    if (techKeys.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select at least one symptom")));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewSubmitScreen(
          symptoms: techKeys.join(", "), // For AI
          readableSymptoms: _selectedSymptoms.join(", "), // For UI
          description: _descriptionController.text.trim(),
          location: _currentLocation,
          latitude: _lat ?? 0.0,
          longitude: _lng ?? 0.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Report Symptoms"), centerTitle: true, backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select all that apply:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _availableSymptoms.map((s) {
                bool isSelected = _selectedSymptoms.contains(s);
                return FilterChip(
                  label: Text(s),
                  selected: isSelected,
                  onSelected: (val) => setState(() => val ? _selectedSymptoms.add(s) : _selectedSymptoms.remove(s)),
                  selectedColor: const Color(0xFF30B1D2).withOpacity(0.2),
                  checkmarkColor: const Color(0xFF30B1D2),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            const Text("Your Location (Precise GPS)", style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on, color: Color(0xFF30B1D2)),
              title: Text(_currentLocation),
              trailing: _isFetchingLocation
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : IconButton(icon: const Icon(Icons.my_location), onPressed: _fetchPreciseLocation),
            ),
            const SizedBox(height: 20),
            const Text("Additional Details", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _descriptionController, maxLines: 3, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Describe severity or duration...")),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitToReview,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF30B1D2), padding: const EdgeInsets.symmetric(vertical: 15)),
                child: const Text("Review & Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}