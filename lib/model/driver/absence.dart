

class Absence {
  final int? id;
  final int userId;
  final int type;
  final String? remark;
  final DateTime? start;
  final DateTime? end;
  final DateTime? createdAt;

  Absence({
    this.id,
    required this.userId,
    required this.type,
    this.remark,
    this.start,
    this.end,
    this.createdAt
});

  factory Absence.fromJson (Map<String, dynamic> json) {
    return Absence(
      id: json['id'],
        userId: json['userId'],
        type: json['type'],
        remark: json['remark'],
        start: json['start'] != null ? DateTime.parse(json['start']) : null,
        end: json['end'] != null ? DateTime.parse(json['end']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null
    );
  }

  Map<String, dynamic> toJson () {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['userId'] = userId;
    data['type'] = type;
    data['remark'] = remark;
    if (start != null) {
      data['start'] = start!.toString();
    }
    if (end != null) {
      data['end'] = end!.toString();
    }
    return data;
  }
}