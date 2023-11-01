

class School {

  final int id;
  final String name;
  final String code;
  final int? addressId;
  final int? type;
  final int status;

  School({
    required this.id,
    required this.name,
    required this.code,
    this.addressId,
    this.type,
    required this.status
});

  factory School.fromJson (Map<String, dynamic> json) {
    return School(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        status: json['status'],
      addressId: json['addressId'],
      type: json['type'],
    );
  }

}