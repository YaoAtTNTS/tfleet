

class StudentNameCardData {
  final String name;
  final int id;
  final int userId;
  final String? url;
  final int? leave;
  final DateTime? start;
  final DateTime? end;
  bool isAbsent;
  int eta;

  StudentNameCardData({
    required this.name,
    required this.id,
    required this.userId,
    required this.url,
    this.leave,
    this.start,
    this.end,
    required this.isAbsent,
    required this.eta
});

}