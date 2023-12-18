import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class GooglePlacesApiScreen extends StatefulWidget {
  const GooglePlacesApiScreen({super.key});

  @override
  State<GooglePlacesApiScreen> createState() => _GooglePlacesApiScreenState();
}

class _GooglePlacesApiScreenState extends State<GooglePlacesApiScreen> {
  List<Marker> _markers = [];
  var _id = 4;

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
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _initialCamPosition = const CameraPosition(
    target: LatLng(24.859768949758976, 67.0524289219591),
    zoom: 14,
  );

  final TextEditingController _predictAddressController =
      TextEditingController();

  var uuid = Uuid();
  String? _sessionToken;
  List _placeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers.addAll(_list);

    _predictAddressController.addListener(() {
      onChange();
      // initController();
    });
  }

  goToDestination() async {
    // _goToTheLake();
    var addressltlg2 = await Geocoder.local
        .findAddressesFromQuery(_predictAddressController.text);

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
          infoWindow: InfoWindow(title: _predictAddressController.text),
          position: LatLng(
            addressltlg2.first.coordinates.latitude!,
            addressltlg2.first.coordinates.longitude!,
          )),
    );
    _id++;
    setState(() {});
  }

  onChange() {
    _sessionToken ??= uuid.v4();
    // controller = await _controller.future;
    getSuggestion(_predictAddressController.text);
  }

  getSuggestion(input) async {
    String kPLACES_API_KEY = 'AIzaSyA4uIN_CJ0XHEeJKrQRnOTeig5D8h03NzQ';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    // print(response);
    if (response.statusCode == 200) {
      _placeList = jsonDecode(response.body)['predictions'];
      setState(() {});
    } else {
      throw Exception('failed to load');
    }
  }

  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight:
              isSearching ? MediaQuery.sizeOf(context).height * 0.3 : null,
          title: isSearching
              ? Column(children: [
                  TextFormField(
                    controller: _predictAddressController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            goToDestination();
                          },
                          icon: const Icon(
                            Icons.search,
                          )),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search places with name',
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                        itemCount: _placeList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () async {
                              // print(_placeList[index]['description']);
                              // goToDestination(_placeList[index]['description']);
                              _predictAddressController.text =
                                  _placeList[index]['description'];
                              print(_placeList[index]['description']);
                            },
                            title: Text(_placeList[index]['description']),
                          );
                        }),
                  )
                ])
              : TextFormField(
                  onTap: () {
                    isSearching = true;
                    setState(() {});
                  },
                  // controller: _predictAddressController,
                  decoration: InputDecoration(
                    // suffixIcon: IconButton(
                    //     onPressed: () {
                    //       goToDestination();
                    //     },
                    //     icon: const Icon(
                    //       Icons.search,
                    //     )),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search places with name',
                  ),
                ),
        ),
        body: GoogleMap(
          onTap: (value) {
            isSearching = false;
            print('$isSearching');
            setState(() {});
          },
          initialCameraPosition: _initialCamPosition,
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
