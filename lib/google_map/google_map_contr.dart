import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_integration/google_map/google_map.dart';
import 'package:location/location.dart';

class GoogleMapScreenController extends GetxController {
  final Completer<GoogleMapController> _controller = Completer();
  final Location location = Location();
  Rx<LocationData?> currentLocation = Rx<LocationData?>(null);
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;

  @override
  void onInit() {
    getCurrentLocation();
    getPolyPoints();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyA4uIN_CJ0XHEeJKrQRnOTeig5D8h03NzQ", // Your Google Map Key
      // PointLatLng(GoogleMapScreen.sourceLocation.latitude,
      //     GoogleMapScreen.sourceLocation.longitude),
      // PointLatLng(GoogleMapScreen.destination.latitude,
      //     GoogleMapScreen.destination.longitude),
      PointLatLng(
        currentLocation.value?.latitude ??
            GoogleMapScreen.sourceLocation.latitude,
        currentLocation.value?.longitude ??
            GoogleMapScreen.sourceLocation.longitude,
      ),
      PointLatLng(GoogleMapScreen.destination.latitude,
          GoogleMapScreen.destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      update();
    }
  }

  void getCurrentLocation() async {
    location.getLocation().then(
      (location) {
        currentLocation.value = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation.value = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        update();
      },
    );
  }
}
