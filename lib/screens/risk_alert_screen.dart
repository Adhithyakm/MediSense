import 'package:flutter/material.dart';

class RiskAlertsScreen extends StatelessWidget {
  final List<dynamic> risks;
  const RiskAlertsScreen({super.key, required this.risks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Environmental Risk Spots")),
      body: risks.isEmpty
          ? const Center(child: Text("No risk images reported in this jurisdiction."))
          : ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: risks.length,
        itemBuilder: (ctx, i) {
          final r = risks[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(r['image'], height: 230, width: double.infinity, fit: BoxFit.cover),
                ),
                ListTile(
                  title: Text(r['risk_type'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(r['location']),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text("AI: ${r['ai_tag']}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}