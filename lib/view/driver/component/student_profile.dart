

import 'package:flutter/material.dart';
import 'package:tfleet/model/driver/pickup_point.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/service/driver/pickup_point_service.dart';
import 'package:tfleet/view/common/profile_image.dart';
import 'package:tfleet/view/driver/component/pup_on_map_view.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key, required this.child}) : super(key: key);

  final Child child;

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {

  PickupPoint? _dropoffPoint;
  PickupPoint? _pickupPoint;
  PickupPoint? _ecaPoint;

  void _getPickupAndDropoffPoint() async {
    if (widget.child.pickupPointIds != null && widget.child.pickupPointIds!.isNotEmpty) {
      for (int id in widget.child.pickupPointIds!) {
        var raw = await PickupPointService.getPickupPoint(id);
        if (raw != null) {
          switch(raw['type']) {
            case 1:
              _pickupPoint = PickupPoint.fromJson(raw);
              break;
            case 2:
              _dropoffPoint = PickupPoint.fromJson(raw);
              break;
            case 3:
              _ecaPoint = PickupPoint.fromJson(raw);
              break;
          }
        }
      }
      if (mounted) {
        setState(() {});
      }
    }
  }


  Widget _iconAndTitle(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Color(0xffff6600),
          size: 24,
        ),
        SizedBox(width: 5,),
        _normalText(text),
      ],
    );
  }

  Widget _locationIconAndTitle(IconData icon, String text, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            switch (index) {
              case 1:
                if (_pickupPoint != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PupOnMapView(pup: _pickupPoint!),
                  ));
                }
                break;
              case 2:
                if (_dropoffPoint != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PupOnMapView(pup: _dropoffPoint!),
                  ));
                }
                break;
              case 3:
                if (_ecaPoint != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PupOnMapView(pup: _ecaPoint!),
                  ));
                }
                break;
              default:
                break;
            }
          },
          icon: Icon(
            icon,
            color: Color(0xffff6600),
            size: 24,
          ),
        ),
        const SizedBox(width: 5,),
        Expanded(child: _normalText(text)),
      ],
    );
  }

  Widget _normalText(String text) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          color: Color(0xff030303),
          fontSize: 18,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.bold
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPickupAndDropoffPoint();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kToolbarHeight,),
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                    widget.child.name,
                  style: const TextStyle(
                    color: Color(0xff030303),
                    fontSize: 24,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.black,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Center(child: ProfileImage(size: 297, url: widget.child.url)),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: _normalText('SID: ${widget.child.sid}'),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: _iconAndTitle(Icons.tour, 'School: ${widget.child.school}'),
          ),
          SizedBox(height: 4,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: _iconAndTitle(Icons.tour, 'Class: ${widget.child.clazz}'),
          ),
          SizedBox(height: 4,),
          _pickupPoint != null ? Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: _locationIconAndTitle(Icons.place, 'Pickup: ${_pickupPoint!.name}', 1),
          ) : Container(),
          SizedBox(height: 4,),
          _dropoffPoint != null ? Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: _locationIconAndTitle(Icons.place, 'Dropoff: ${_dropoffPoint!.name}', 2),
          ) : Container(),
          SizedBox(height: 4,),
          _ecaPoint != null ? Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: _locationIconAndTitle(Icons.place, 'ECA: ${_ecaPoint!.name}', 3),
          ) : Container(),
        ],
      ),
    );
  }
}
