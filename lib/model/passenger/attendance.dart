
import 'package:tfleet/utils/format_utils.dart';

class Attendance {

  int? id;
  int? userId;
  final int? tripId;
  final String routeNo;
  int status;
  final int? childId;
  final String childName;
  final DateTime? actualBoard;
  final int? estBoard;
  final DateTime? actualAlight;
  final int? estAlight;
  final String? vehicleNo;
  final String? driverName;
  final String? attendantName;
  final String? boardPoint;
  final String? alightPoint;

  Attendance ({
    this.id,
    this.userId,
    required this.tripId,
    required this.routeNo,
    required this.status,
    required this.childId,
    required this.childName,
    this.actualBoard,
    this.estBoard,
    this.actualAlight,
    this.estAlight,
    this.vehicleNo,
    this.driverName,
    this.attendantName,
    this.boardPoint,
    this.alightPoint
});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      userId: json['userId'],
        tripId: json['tripId'],
        routeNo: json['routeNo'],
        status: json['status'],
        childId: json['childId'],
        childName: json['childName']!,
        actualBoard: json['actualBoard'] != null ? DateTime.parse(json['actualBoard']) : null,
        estBoard: json['estBoard'],
        actualAlight: json['actualAlight'] != null ? DateTime.parse(json['actualAlight']) : null,
        estAlight: json['estAlight'],
        vehicleNo: json['vehicleNo'],
      driverName: json['driverName'],
      attendantName: json['attendantName'],
      boardPoint: json['boardPoint'],
      alightPoint: json['alightPoint']
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['tripId'] = tripId;
    data['routeNo'] = routeNo;
    data['childId'] = childId;
    data['childName'] = childName;
    data['status'] = status;
    data['actualBoard'] = actualBoard?.toString();
    data['boardPoint'] = boardPoint;
    data['actualAlight'] = actualAlight?.toString();
    data['alightPoint'] = alightPoint;
    return data;
  }

}