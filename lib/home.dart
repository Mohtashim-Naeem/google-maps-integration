import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeForMaps extends StatefulWidget {
  const HomeForMaps({super.key});

  @override
  State<HomeForMaps> createState() => _HomeForMapsState();
}

class _HomeForMapsState extends State<HomeForMaps> {
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(24.859768949758976, 67.0524289219591),
    zoom: 14,
  );

  final TextEditingController _addressController = TextEditingController(
      text: 'CRFG+2GP, Al Haram, Makkah 24231, Saudi Arabia');
  // latlong to saudi arabia
  static const CameraPosition saudiArabia = CameraPosition(
      target: LatLng(
    23.691009972136687,
    45.23576748787693,
  ));

  // reaching to saudi arabia
  Future _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(saudiArabia));
  }

  getLtLng() async {
    var addressltlg = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(21.422797432723225, 39.826180961343354));

    // address = addressltlg.first.addressLine!;
    setState(() {});
  }

  // static const CameraPosition destination = CameraPosition(target: LatLng());

  // reaching to saudi arabia
  Future _goToTheDestination() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(saudiArabia));
  }

  List<Marker> _markers = [];
  final List<Marker> _list = [
    const Marker(
      markerId: MarkerId('1'),
      infoWindow: InfoWindow(
        title: 'smit',
      ),
      position: LatLng(24.88571638795687, 67.06835475594194),
    ),
    const Marker(
      markerId: MarkerId('2'),
      infoWindow: InfoWindow(
        title: 'my currrent location',
      ),
      position: LatLng(24.859768949758976, 67.0524289219591),
    ),
    const Marker(
      markerId: MarkerId('3'),
      infoWindow: InfoWindow(
        title: 'السعودية',
      ),
      position: LatLng(23.89206386269536, 46.07072836597046),
    ),
  ];

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

  @override
  void initState() {
    super.initState();
    _markers.addAll(_list);
    getCurrentLocation();
  }

  var _id = 4;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        drawer: const Drawer(),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          // title: Text('Google Maps'),
          title: TextField(
            controller: _addressController,
// decoration: InputDecoration(),
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.search,
          ),
          onPressed: () async {
            // _goToTheLake();
            var addressltlg2 = await Geocoder.local
                .findAddressesFromQuery(_addressController.text);

            // address2 = addressltlg2.first.coordinates;
            final GoogleMapController controller = await _controller.future;
            await controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(
                    addressltlg2.first.coordinates.latitude!,
                    addressltlg2.first.coordinates.longitude!,
                  ),
                  zoom: 19),
            ));
            _markers.add(
              Marker(
                  markerId: MarkerId("$_id"),
                  infoWindow: InfoWindow(title: _addressController.text),
                  position: LatLng(
                    addressltlg2.first.coordinates.latitude!,
                    addressltlg2.first.coordinates.longitude!,
                  )),
            );
            _id++;
            setState(() {});
          },
        ),
        body: GoogleMap(
          initialCameraPosition: _cameraPosition,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: Set.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
