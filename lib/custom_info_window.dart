import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomInfoWindowGoogleMaps extends StatefulWidget {
  const CustomInfoWindowGoogleMaps({super.key});

  @override
  State<CustomInfoWindowGoogleMaps> createState() =>
      _CustomInfoWindowGoogleMapsState();
}

class _CustomInfoWindowGoogleMapsState
    extends State<CustomInfoWindowGoogleMaps> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final List<Marker> _markers = [];
  List images = [
    'assets/images/car.png',
    'assets/images/car.png',
    'assets/images/car.png',
    'assets/images/car.png',
  ];
  final List<LatLng> _latlngs = [
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
    super.initState();
    loadData();
  }

  loadData() async {
    for (var i = 0; i < images.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('$i'),
          position: _latlngs[i],
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
                Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 300,
                        height: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://images.pexels.com/photos/1566837/pexels-photo-1566837.jpeg?cs=srgb&dl=pexels-narda-yescas-1566837.jpg&fm=jpg'),
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.high),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Colors.red,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                'Beef Tacos',
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '.3 mi.',
                              // widget.data!.date!,
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          'Help me finish these tacos! I got a platter from Costco and it’s too much.',
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                // LatLng(33.6844, 73.0479),
                _latlngs[i]);
          },
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                23.89206386269536,
                46.07072836597046,
              ),
            ),
            markers: Set<Marker>.of(_markers),
            onMapCreated: (controller) {
              _customInfoWindowController.googleMapController = controller;
            },
            onTap: (positioned) {
              _customInfoWindowController.hideInfoWindow!();
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 200,
            width: 300,
            offset: 35,
          ),
        ],
      ),
    );
  }
}
