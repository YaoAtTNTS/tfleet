

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tfleet/model/geo_coordinates.dart';
import 'package:tfleet/utils/global.dart';
import './pickup_point.dart';

class NotifiablePickupPointList extends ChangeNotifier {

  NotifiablePickupPointList({required this.pickupPoints});

  List<PickupPoint> pickupPoints;

  addPickupPoint(PickupPoint pickupPoint) {
    pickupPoints.add(pickupPoint);
  }

  addAll (List<PickupPoint> list) {
    pickupPoints.addAll(list);
  }

  PickupPoint getPickupPoint(int index) {
    return pickupPoints[index];
  }

  movePickupPointToTop (int index) {
    if (pickupPoints.length > index) {
      PickupPoint p0 = pickupPoints[0];
      bool isNoStus = true;
      for (var stu in p0.students) {
        if (!Global.absentIds.contains(stu['id'])) {
          isNoStus = false;
        }
      }
      PickupPoint pp = pickupPoints[index];
      pickupPoints.removeAt(index);
      if (isNoStus) {
        pickupPoints.removeAt(0);
      }
      pickupPoints.insert(0, pp);
      notifyListeners();
    }
  }

  removeTopPickupPoint() {
    if (pickupPoints.isNotEmpty) {
      PickupPoint p0 = pickupPoints[0];
      pickupPoints.removeAt(0);
      if (pickupPoints.isNotEmpty) {
        // pickupPoints.first.students.removeWhere((element) => Global.absentIds.contains(element['id']));
        for (var element in pickupPoints.first.students) {
          if (Global.absentIds.contains(element['id'])) {
            element['isAbsent'] = true;
          }
        }
      }
      p0.status = 1;
      pickupPoints.add(p0);
      notifyListeners();
    }
  }

  String getRemainingPickupPointIds() {
    List<int> ids = [];
    for(PickupPoint pp in pickupPoints) {
      ids.add(pp.id);
    }
    return ids.join(';');
  }

  int length() {
    return pickupPoints.length;
  }

  bool isNotEmpty() {
    return pickupPoints.isNotEmpty;
  }
}