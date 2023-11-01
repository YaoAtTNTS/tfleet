

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfleet/model/driver/pickup_point.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/model/geo_coordinates.dart';
import 'package:tfleet/service/driver/pickup_point_service.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/service/passenger/attendance_service.dart';
import 'package:tfleet/utils/global.dart';

class ActiveTrip {

  ActiveTrip._();

  static final ActiveTrip _instance = ActiveTrip._();

  static ActiveTrip get instance => _instance;

  Trip? activeTrip;

  List<PickupPoint> pickupPoints = [];

  bool _isAvailable = true;

  /*Future init() async {
    if (_isAvailable) {
      _isAvailable = false;
      var rawTrip = await TripService.getActiveTrip();
      pickupPoints.clear();
      Global.remainingPups.clear();
      Global.absentIds.clear();
      if (rawTrip == null) {
        return;
      }
      activeTrip = Trip.fromJson(rawTrip);
      if (activeTrip != null) {
        Global.currentVehicleNo = activeTrip!.vehicleNo;
        List list = await PickupPointService.getPickupPoints(activeTrip!.routeId);
        for (Map<String, dynamic> raw in list) {
          PickupPoint pp = PickupPoint.fromJson(raw);
          Global.remainingPups.add(GeoCoordinates(lon: pp.lon, lat: pp.lat));
          pickupPoints.add(pp);
        }
        if (pickupPoints.length > 1) {
          if (activeTrip!.type == 1) {
            pickupPoints.last.type = 2;
            for (int i = 0; i < pickupPoints.length - 1; i++) {
              pickupPoints.last.students.clear();
              pickupPoints.last.students.addAll(pickupPoints[i].students);
            }
          } else {
            pickupPoints.first.type = 1;
            for (int i = 1; i < pickupPoints.length; i++) {
              pickupPoints.first.students.clear();
              print('$i: ${pickupPoints[i].students}');
              pickupPoints.first.students.addAll(pickupPoints[i].students);
            }
          }
        }
      }
    }
  }*/

  Future assign(Trip trip) async {
    pickupPoints.clear();
    Global.remainingPups.clear();
    Global.absentIds.clear();
    activeTrip = trip;
    Global.currentVehicleNo = activeTrip!.vehicleNo;
    List list = await PickupPointService.getPickupPoints(activeTrip!.routeId);

    /*List<String> passPups = Global.restorePassedPups(trip.id);
    if (passPups.isNotEmpty) {
      list.removeWhere((element) => passPups.contains(element['id']));
    } else {
      Global.savePassedPups(trip.id);
    }*/
    for (Map<String, dynamic> raw in list) {
      PickupPoint pp = PickupPoint.fromJson(raw);
      Global.remainingPups.add(GeoCoordinates(lon: pp.lon, lat: pp.lat));
      pickupPoints.add(pp);
    }

    // if (pickupPoints.length > 1) {
    //   if (activeTrip!.type == 1) {
    //     pickupPoints.last.type = 2;
    //     pickupPoints.last.students.clear();
    //     for (int i = 0; i < pickupPoints.length - 1; i++) {
    //       pickupPoints.last.students.addAll(pickupPoints[i].students);
    //     }
    //   } else {
    //     pickupPoints.first.type = 1;
    //     pickupPoints.first.students.clear();
    //     for (int i = 1; i < pickupPoints.length; i++) {
    //       pickupPoints.first.students.addAll(pickupPoints[i].students);
    //     }
    //   }
    // }
  }

}