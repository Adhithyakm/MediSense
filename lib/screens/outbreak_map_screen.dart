import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OutbreakMapScreen extends StatefulWidget {
  final List<dynamic> alerts;
  final String district;

  const OutbreakMapScreen({super.key, required this.alerts, required this.district});

  @override
  State<OutbreakMapScreen> createState() => _OutbreakMapScreenState();
}

class _OutbreakMapScreenState extends State<OutbreakMapScreen> {
  Set<Circle> _circles = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _buildMapData();
  }

  void _buildMapData() {
    for (var alert in widget.alerts) {
      double lat = alert['lat'];
      double lng = alert['lng'];
      int count = alert['case_count'];
      String place = alert['place_name'];
      String disease = alert['disease'];

      // 🔴 1. Add Circle (Red Hotspot)
      _circles.add(
        Circle(
          circleId: CircleId("circle_$place"),
          center: LatLng(lat, lng),
          radius: 1000 + (count * 300), // Larger circle for more cases
          fillColor: Colors.red.withOpacity(0.4),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ),
      );

      // 📍 2. Add Marker (Information Pin)
      _markers.add(
        Marker(
          markerId: MarkerId("marker_$place"),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: place,
            snippet: "${disease.toUpperCase()}: $count cases",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.district} Outbreak Analysis")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.alerts.isNotEmpty
              ? LatLng(widget.alerts[0]['lat'], widget.alerts[0]['lng'])
              : const LatLng(10.1632, 76.6413),
          zoom: 10,
        ),
        circles: _circles,
        markers: _markers,
      ),
    );
  }
}