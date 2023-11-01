

import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/driver/pickup_point.dart';
import 'package:tfleet/model/passenger/address.dart';
import 'package:tfleet/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class PupOnMapView extends StatefulWidget {
  PupOnMapView({Key? key, required this.pup}) : super(key: key);

  final PickupPoint pup;

  @override
  State<PupOnMapView> createState() => _PupOnMapViewState();
}

class _PupOnMapViewState extends State<PupOnMapView> {

  static late CameraPosition _initialCameraPosition;

  late GoogleMapController _googleMapController;

  Marker? _origin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialCameraPosition = CameraPosition(
        target: LatLng(widget.pup.lat, widget.pup.lon),
        zoom: 15
    );
    _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: InfoWindow(
            title: widget.pup.name,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: LatLng(widget.pup.lat, widget.pup.lon)
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe40947),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: Text(widget.pup.name),
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(Icons.keyboard))
        // ],
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: {
          if (_origin != null) _origin!,
        },
        onLongPress: _addMarker,
      ),
    );
  }

  void _addMarker(LatLng pos) async {

  }

}
