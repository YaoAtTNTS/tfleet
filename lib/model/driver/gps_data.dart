

class GpsData {

  final double lon;
  final double lat;
  final DateTime? time;
  final int tripId;

  GpsData({
    required this.lon,
    required this.lat,
    this.time,
    required this.tripId,
});

  factory GpsData.fromJson (Map<String, dynamic> json) {
    return GpsData(
        lon: json['lon'],
        lat: json['lat'],
        time: json['time'],
        tripId: json['tripId'],
    );
  }

  Map<String, dynamic> toJson () {
    Map<String, dynamic> data = <String, dynamic>{};
    data['lon'] = lon;
    data['lat'] = lat;
    data['tripId'] = tripId;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Lon: $lon, Lat: $lat, time: $time';
  }
}