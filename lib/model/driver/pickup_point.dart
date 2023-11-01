

class PickupPoint {

  final int id;
  // final int routeId;
  final String? routeNo;
  // final int sequenceId;
  final double lat;
  final double lon;
  final String name;
  final List students;
  final int eta;
  int type;
  final String school;
  int status = 0;

  PickupPoint({
    required this.id,
    // required this.routeId,
    required this.routeNo,
    // required this.sequenceId,
    required this.lat,
    required this.lon,
    required this.name,
    required this.students,
    required this.eta,
    required this.type,
    required this.school
  });

  factory PickupPoint.fromJson (Map<String, dynamic> json) {
    return PickupPoint(
        id: json['id'],
        // routeId: json['routeId'],
        routeNo: json['routeNo'],
        // sequenceId: json['sequenceId'],
        lat: json['latitude'],
        lon: json['longitude'],
        name: json['name'],
        students: json['students'] ?? [],
        eta: json['eta'],
      type: json['type'],
      school: json['school']
    );
  }

}