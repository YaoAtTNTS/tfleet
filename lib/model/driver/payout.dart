

class Payout {

  final int id;
  final double due;
  final double paid;
  final String month;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? paidAt;
  final int status;

  Payout({
    required this.id,
    required this.due,
    required this.paid,
    required this.month,
    required this.createdAt,
    this.updatedAt,
    required this.paidAt,
    required this.status
});

  factory Payout.fromJson(Map<String, dynamic> json) {
    return Payout(
        id: json['id'],
        due: json['due'],
        paid: json['paid'],
        month: json['month'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        paidAt: json['paidAt'],
        status: json['status']
    );
  }
}