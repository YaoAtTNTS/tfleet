

import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/passenger/address.dart';
import 'package:tfleet/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.33210, 103.89169),
    zoom: 15
  );

  late GoogleMapController _googleMapController;

  Marker? _origin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        title: Text(AppLocalizations.of(context)?.pinYourAddress ?? 'Pin Your Address'),
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
    _origin?.onTap;
    Placemark? address = await addressFromCoordinates(pos);
    Address address2 = Address(userId: Global.getUserId()!, address: address?.street ?? '', postalCode: address?.postalCode ?? '',
        longitude: pos.longitude, latitude: pos.latitude, name: address?.name);
    Global.saveAddress(address2);
    setState(() {
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: InfoWindow(
            title: address?.name ?? '',
          snippet: address?.street ?? ''
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos
      );
    });
  }

  Future<Placemark?> addressFromCoordinates(LatLng pos) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    return placemarks[0];
  }
}
