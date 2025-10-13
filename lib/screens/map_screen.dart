import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        backgroundColor: const Color(0xFF30B1D2),
      ),
      body: const Center(
        child: Text("Map Page Content"),
      ),
    );
  }
}
