import 'package:flutter/material.dart';

class EConsultationScreen extends StatelessWidget {

  final String fullName;
  const EConsultationScreen({Key? key, required this.fullName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("eConsultation"),
        backgroundColor: const Color(0xFF30B1D2),
      ),
      body: const Center(
        child: Text("This is the eConsultation Page"),
      ),
    );
  }
}
