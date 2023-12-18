import 'dart:async';
import 'dart:collection';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonGoogleMaps extends StatefulWidget {
  const PolygonGoogleMaps({super.key});

  @override
  State<PolygonGoogleMaps> createState() => _PolygonGoogleMapsState();
}

class _PolygonGoogleMapsState extends State<PolygonGoogleMaps> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final List<Marker> _markers = [];

  final List<LatLng> _latlngs = [
    const LatLng(24.861716223300252, 67.05284792489684),
    const LatLng(24.856829386417736, 67.05209690636899),
    const LatLng(24.856615217834644, 67.05359894342469),
    const LatLng(24.86448080245637, 67.04643208097197),

    // const LatLng(
    //   43.89206386269536,
    //   76.07072836597046,
    // ),
    // const LatLng(
    //   53.89206386269536,
    //   66.07072836597046,
    // ),
  ];

  Set<Polygon> _polygon = HashSet<Polygon>();
  @override
  void initState() {
    super.initState();
    loadData();
    _polygon.add(Polygon(
        polygonId: const PolygonId('1'),
        fillColor: Colors.black.withOpacity(0.3),
        points: _latlngs,
        strokeWidth: 2));
  }

  loadData() async {
    for (var i = 0; i < _latlngs.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('$i'),
          position: _latlngs[i],
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(
            23.89206386269536,
            46.07072836597046,
          ),
        ),
        markers: Set<Marker>.of(_markers),
        polygons: _polygon,
      ),
    );
  }
}
