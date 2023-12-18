import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkersGoogleMaps extends StatefulWidget {
  const CustomMarkersGoogleMaps({super.key});

  @override
  State<CustomMarkersGoogleMaps> createState() =>
      _CustomMarkersGoogleMapsState();
}

class _CustomMarkersGoogleMapsState extends State<CustomMarkersGoogleMaps> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<Marker> _markers = [];
  List images = [
    'assets/images/car.png',
    'assets/images/car.png',
    'assets/images/car.png',
    'assets/images/car.png',
  ];
  List<LatLng> _latlngs = [
    LatLng(
      23.89206386269536,
      46.07072836597046,
    ),
    LatLng(
      33.89206386269536,
      56.07072836597046,
    ),
    LatLng(
      43.89206386269536,
      76.07072836597046,
    ),
    LatLng(
      53.89206386269536,
      66.07072836597046,
    ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    for (var i = 0; i < images.length; i++) {
      final Uint8List markerIcon =
          await getBytesFromAsset(images[i].toString(), 100);
      _markers.add(
        Marker(
          markerId: MarkerId('$i'),
          position: _latlngs[i],
          infoWindow: InfoWindow(
            title: 'title: $i',
          ),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ),
      );
    }
    setState(() {});
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            23.89206386269536,
            46.07072836597046,
          ),
        ),
        markers: Set<Marker>.of(_markers),
        onMapCreated: (controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
