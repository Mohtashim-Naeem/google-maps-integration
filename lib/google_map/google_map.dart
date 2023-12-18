import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_integration/google_map/google_map_contr.dart';

class GoogleMapScreen extends StatelessWidget {
  final GoogleMapScreenController controller =
      Get.put(GoogleMapScreenController());
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.4223, -122.0848);
  static const LatLng destination = LatLng(37.3346, -122.0090);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return controller.currentLocation.value == null
              ? const Center(child: Text("Loading"))
              : GoogleMap(
                  onMapCreated: (mapController) {
                    _controller.complete(mapController);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(controller.currentLocation.value!.latitude!,
                        controller.currentLocation.value!.longitude!),
                    zoom: 13.5,
                  ),
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("route"),
                      points: controller.polylineCoordinates,
                      color: const Color(0xFF7B61FF),
                      width: 6,
                    ),
                  },
                  markers: {
                    Marker(
                        markerId: const MarkerId("currentLocation"),
                        position: LatLng(
                          controller.currentLocation.value!.latitude!,
                          controller.currentLocation.value!.longitude!,
                        ),
                        infoWindow: InfoWindow(title: 'current')),
                    const Marker(
                      markerId: MarkerId("source"),
                      position: sourceLocation,
                    ),
                    const Marker(
                      markerId: MarkerId("destination"),
                      position: destination,
                    ),
                  },
                );
        },
      ),
    );
  }
}
