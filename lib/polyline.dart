import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineGoogleMaps extends StatefulWidget {
  const PolylineGoogleMaps({super.key});

  @override
  State<PolylineGoogleMaps> createState() => _PolylineGoogleMapsState();
}

class _PolylineGoogleMapsState extends State<PolylineGoogleMaps> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final List<Marker> _markers = [];

  final List<LatLng> _latlngs = [
    const LatLng(24.861716223300252, 67.05284792489684),
    const LatLng(24.856829386417736, 67.05209690636899),
    // const LatLng(24.856615217834644, 67.05359894342469),
    // const LatLng(24.86448080245637, 67.04643208097197),
  ];

  Future<Position?> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print(error);
    });

    return await Geolocator.getCurrentPosition();
    // moveToCurrentLocation(location: location);
  }

  final Set<Polyline> _polyline = {};
//  final Future< Position> currentLocation =;
  CameraPosition? _cameraPosition;
  @override
  void initState() {
    super.initState();
    loadData();
    // _latlngs.add();

    // currentLocation = getCurrentLocation();
    _polyline.add(Polyline(
      polylineId: const PolylineId('1'),
      color: Colors.black.withOpacity(0.3),
      points: _latlngs,
      width: 2,
    ));
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
        polylines: _polyline,
      ),
    );
  }
}
