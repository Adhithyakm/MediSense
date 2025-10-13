import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        backgroundColor: const Color(0xFF30B1D2),
      ),
      body: const Center(
        child: Text("Tasks Page Content"),
      ),
    );
  }
}
