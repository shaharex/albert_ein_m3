import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(50, 16);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 8.0,
        ),
        markers:  {
           const Marker(
            markerId: MarkerId('Shaha\'s house'),
            position: LatLng(6, 50.20),
            infoWindow: InfoWindow(
              title: "Shaha\'s house",
              snippet: "This is the Shah's home",
            )
          ),
           const Marker(
            markerId: MarkerId('Shaha\'s house'),
            position: LatLng(0.0, 0.0),
            infoWindow: InfoWindow(
              title: "Shaha\'s house",
              snippet: "This is the Shah's home",
            )
          ),
        },
      ),
    );
  }
}
