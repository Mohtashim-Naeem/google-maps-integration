import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';

class ConvertLatLng extends StatefulWidget {
  const ConvertLatLng({super.key});

  @override
  State<ConvertLatLng> createState() => _ConvertLatLngState();
}

class _ConvertLatLngState extends State<ConvertLatLng> {
  String address = ' ';
  String address2 = ' ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(address),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                var addressltlg = await Geocoder.local
                    .findAddressesFromCoordinates(
                        Coordinates(21.422797432723225, 39.826180961343354));

                address = addressltlg.first.addressLine!;
                setState(() {});
              },
              child: const Text(
                'Convert Latlng to Address',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(address2),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                var addressltlg2 = await Geocoder.local.findAddressesFromQuery(
                    'CRFG+2GP, Al Haram, Makkah 24231, Saudi Arabia');

                address2 = addressltlg2.first.coordinates.toString();
                setState(() {});
              },
              child: const Text(
                'Convert Address to Latlng',
              ),
            ),
          )
        ]),
      ),
    );
  }
}
