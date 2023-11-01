

class Address {
  int? id;
  final int userId;
  String? name;
  String? unitNo;
  String address;
  String postalCode;
  double longitude;
  double latitude;
  DateTime? createdAt;
  DateTime? updatedAt;

  
  Address({
    this.id,
    required this.userId,
    this.name,
    this.unitNo,
    required this.address,
    required this.postalCode,
    required this.longitude,
    required this.latitude,
    this.createdAt,
    this.updatedAt
});
  
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        unitNo: json['unitNo'],
        address: json['address']!,
        postalCode: json['postalCode']!,
        name: json['name'],
        id: json['id'],
        userId: json['userId']!,
      longitude: json['longitude'],
      latitude: json['latitude'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['unitNo'] = unitNo;
    data['name'] = name;
    data['address'] = address;
    data['postalCode'] = postalCode;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    if (createdAt != null) {
      data['createdAt'] = createdAt!.toIso8601String();
    }
    data['updatedAt'] = updatedAt;
    return data;
  }
  
}