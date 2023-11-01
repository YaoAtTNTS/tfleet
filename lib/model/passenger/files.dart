

class Files {

  final int id;
  final String title;
  final int ownerId;
  final int? termNo;
  final String? school;
  final int? year;
  final int? type;
  final String url;
  final String? remark;
  final int status;
  final String? createdAt;


  Files({
    required this.id,
    required this.title,
    required this.ownerId,
    this.termNo,
    this.school,
    this.year,
    this.type,
    required this.url,
    this.remark,
    required this.status,
    this.createdAt,
});

  factory Files.fromJson(Map<String, dynamic> json) {
    return Files(
        id: json['id'],
        title: json['title'],
        ownerId: json['ownerId'],
        termNo: json['termNo'],
        school: json['school'],
        year: json['year'],
        type: json['type'],
        url: json['url'],
        remark: json['remark'],
        status: json['status'],
        createdAt: json['createdAt'],
    );
  }
}