


import 'dart:convert';

class Trip {

  final int id;
  int? ownerId;
  int? driverId;
  int? attendantId;
  final int type;
  String? vehicleNo;
  int plannedPax;
  int boardPax;
  int alightPax;
  final int routeId;
  final String routeNo;
  final double? startLat;
  final double? startLon;
  final String? departure;
  final double? endLat;
  final double? endLon;
  final String? destination;
  final DateTime? createdAt;  // status: 0
  final DateTime? cancelledAt;    // -1
  final DateTime? plannedStart;
  DateTime? startedAt;    // 1
  final DateTime? plannedEnd;
  DateTime? endedAt;    // 2
  String? remark;
  final int status; //0 - created,  1 - assigned, 2 - re-assigned, 3 - started,  4 - complete,  -1 - cancelled
  final int adjustment;
  final String? school;
  final int? adjustedPax;
  final int? absentPax;
  final String? driverName;
  final String? attendantName;
  final String? subconName;
  bool visible = true;
  bool isFullTrip = false;
  String date = '';
  int? todayHasTrip;

  Trip({
    required this.id,
    this.ownerId,
    this.driverId,
    this.attendantId,
    required this.type,
    this.vehicleNo,
    required this.plannedPax,
    required this.boardPax,
    required this.alightPax,
    required this.routeId,
    required this.routeNo,
    required this.startLat,
    required this.startLon,
    required this.departure,
    required this.endLat,
    required this.endLon,
    required this.destination,
    required this.createdAt,
    this.cancelledAt,
    required this.plannedStart,
    required this.plannedEnd,
    this.startedAt,
    required this.endedAt,
    this.remark,
    required this.status,
    required this.adjustment,
    this.school,
    this.adjustedPax,
    this.absentPax,
    this.driverName,
    this.attendantName,
    this.subconName,
});

  factory Trip.fromJson (Map<String, dynamic> json) {
    return Trip(
        id: json['id'],
        ownerId: json['ownerId'],
        driverId: json['driverId'],
        attendantId: json['attendantId'],
        type: json['type'],
        vehicleNo: json['vehicleNo'],
        plannedPax: json['plannedPax'] ?? 0,
        boardPax: json['boardPax'] ?? 0,
        alightPax: json['alightPax'] ?? 0,
        routeId: json['routeId'],
        routeNo: json['routeNo'] ?? '',
        startLat: json['startLat'],
        startLon: json['startLon'],
        departure: json['departure'],
        endLat: json['endLat'],
        endLon: json['endLon'],
        destination: json['destination'],
        createdAt: json['createdAt'] is String ? DateTime.parse(json['createdAt']) : json['createdAt'],
        cancelledAt: json['cancelledAt'] is String ? DateTime.parse(json['cancelledAt']) : json['cancelledAt'],
        plannedStart: json['plannedStart'] is String ? DateTime.parse(json['plannedStart']).toLocal() : json['plannedStart'],
        plannedEnd: json['plannedEnd'] is String ? DateTime.parse(json['plannedEnd']).toLocal() : json['plannedEnd'],
        startedAt: json['startedAt'] is String ? DateTime.parse(json['startedAt']).toLocal() : json['startedAt'],
        endedAt: json['endedAt'] is String ? DateTime.parse(json['endedAt']).toLocal() : json['endedAt'],
        remark: json['remark'],
        status: json['status'],
        adjustment: json['adjustment'],
      school: json['school'],
      adjustedPax: json['adjustedPax'],
      absentPax: json['absentPax'],
      driverName: json['driverName'],
      attendantName: json['attendantName'],
      subconName: json['subconName']
    );
  }

  Map<String, dynamic> toJson () {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ownerId'] = ownerId;
    data['driverId'] = driverId;
    data['attendantId'] = attendantId;
    data['type'] = type;
    data['vehicleNo'] = vehicleNo;
    data['plannedPax'] = plannedPax;
    data['boardPax'] = boardPax;
    data['alightPax'] = alightPax;
    data['routeId'] = routeId;
    data['routeNo'] = routeNo;
    data['startLat'] = startLat;
    data['startLon'] = startLon;
    data['departure'] = departure;
    data['endLat'] = endLat;
    data['endLon'] = endLon;
    data['destination'] = destination;
    data['createdAt'] = createdAt;
    data['cancelledAt'] = cancelledAt;
    data['plannedStart'] = plannedStart;
    data['plannedEnd'] = plannedEnd;
    data['startedAt'] = startedAt;
    data['endedAt'] = endedAt;
    data['remark'] = remark;
    data['status'] = status;
    data['adjustment'] = adjustment;
    return data;
  }

}