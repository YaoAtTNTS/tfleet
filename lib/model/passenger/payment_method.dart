

class PaymentMethod {

  final String method;
  final String no;

  PaymentMethod({
    required this.method,
    required this.no
});

  factory PaymentMethod.fromJson(Map<String, String> json) {
    return PaymentMethod(method: json['method']!, no: json['no']!);
  }
}