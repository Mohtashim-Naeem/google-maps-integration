import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetCurrentLocation extends StatefulWidget {
  const GetCurrentLocation({super.key});

  @override
  State<GetCurrentLocation> createState() => _GetCurrentLocationState();
}

class _GetCurrentLocationState extends State<GetCurrentLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _initCameraPosition = const CameraPosition(
      target: LatLng(23.691009972136687, 45.23576748787693));

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print(error);
    });

    return await Geolocator.getCurrentPosition();
    // moveToCurrentLocation(location: location);
  }

  moveToCurrentLocation({location}) async {
    CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(
        location.altitude,
        location.longitude,
      ),
      zoom: 19,
    );
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            getCurrentLocation().then((value) async {
              // await moveToCurrentLocation(location: value);
              CameraPosition cameraPosition = CameraPosition(
                target: LatLng(
                  value.latitude,
                  value.longitude,
                ),
                zoom: 19,
              );
              final GoogleMapController controller = await _controller.future;

              await controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});
            });
          },
          label: const Text('Go to current Location'),
        ),
        body: GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _initCameraPosition,
        ),
      ),
    );
  }
}
