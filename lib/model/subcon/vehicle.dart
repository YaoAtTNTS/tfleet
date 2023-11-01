

import 'package:flutter/foundation.dart';

class Vehicle {
  
  int? id;
  final String vehicleNo;
  final int ownerId;
  final String ownerName;
  final String make;
  final String model;
  final String type;
  final String? remark;
  final int capacity;
  int? defaultDriverId;
  int status;
  
  Vehicle({
    this.id,
    required this.vehicleNo,
    required this.ownerId,
    required this.ownerName,
    required this.make,
    required this.model,
    required this.type,
    this.remark,
    required this.capacity,
    required this.status,
    this.defaultDriverId
});
  
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        id: json['id'],
        vehicleNo: json['vehicleNo'], 
        ownerId: json['ownerId'], 
        ownerName: json['ownerName'], 
        make: json['make'], 
        model: json['model'], 
        type: json['type'],
        remark: json['remark'],
        capacity: json['capacity'], 
        defaultDriverId: json['defaultDriverId'],
        status: json['status']
    );
  }
  
  Map<String, dynamic> toJson () {
    Map<String, dynamic> data = <String, dynamic>{};
     data['vehicleNo'] = vehicleNo;
     data['ownerId'] = ownerId;
     data['ownerName'] = ownerName;
     data['make'] = make;
     data['model'] = model;
     data['type'] = type;
     data['remark'] = remark;
     data['capacity'] = capacity;
     data['defaultDriverId'] = defaultDriverId;
     data['status'] = status;
    return data;
  }
  
  
}