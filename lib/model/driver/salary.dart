

class Salary {

  final int id;
  final double salary;
  final double tripsAmount;
  final String month;

  Salary({
    required this.id,
    required this.salary,
    required this.tripsAmount,
    required this.month,
  });

  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
        id: json['id'],
        salary: json['salary'],
        tripsAmount: json['tripsAmount'],
        month: json['month'],
    );
  }

}