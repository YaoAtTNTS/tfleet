

import 'package:tfleet/model/passenger/address.dart';

class Child {

  int? id;
  final int userId;
  String? sid;
  String name;
  int gender;   // 1 - male; 2 - female
  final String school;
  String clazz;
  String? url;
  final Address address;
  final List? pickupPointIds;
  String? area;
  String? cardId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  int status;
  String? requestedService;
  final String? assignedService;
  final int? leaveId;
  final DateTime? leaveStart;
  final DateTime? leaveEnd;
  final int? leaveType;
  // bool isAbsent = false;
  bool isNA = false;
  bool isECA_SP_SD = false;

  Child({
    this.id,
    required this.userId,
    this.sid,
    required this.name,
    required this.gender,
    required this.school,
    required this.clazz,
    this.url,
    this.pickupPointIds,
    required this.address,
    this.area,
    this.cardId,
    this.createdAt,
    this.updatedAt,
    required this.status,
    this.requestedService,
    this.assignedService,
    this.leaveId,
    this.leaveStart,
    this.leaveEnd,
    this.leaveType
});

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
        name: json['name']!,
        gender: json['gender'],
        school: json['school']!,
        clazz: json['clazz'],
        url: json['url'],
        address: json['address'] != null ? Address.fromJson(json['address']) : Address(
            userId: 0,
            address: '',
            postalCode: '',
            longitude: 0.0,
            latitude: 0.0
        ),
        pickupPointIds: json['pickupPointIds'],
        area: json['area'],
        userId: json['userId']!,
        sid: json['sid'],
        id: json['id'],
        cardId: json['cardId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      status: json['status'],
      requestedService: json['requestedService'],
      assignedService: json['assignedService'],
      leaveId: json['leaveId'],
      leaveStart: json['leaveStart'] != null ? DateTime.parse(json['leaveStart']) : null,
      leaveEnd: json['leaveEnd'] != null ? DateTime.parse(json['leaveEnd']) : null,
      leaveType: json['leaveType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['userId'] = userId;
    data['name'] = name;
    data['gender'] = gender;
    data['school'] = school;
    data['clazz'] = clazz;
    data['addressId'] = address.id;
    data['area'] = area;
    if (url != null) {
      data['url'] = url;
    }
    if (cardId != null) {
      data['cardId'] = cardId;
    }
    data['requestedService'] = requestedService;
    return data;
  }
  
}