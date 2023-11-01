

class User {

  int? id;
  int? ownerId;
  final String account;
  final String name;
  final String? email;
  final String password;
  String? url;
  final int role; // 1 - passenger; 2 - driver
  String? fcmToken;

  User({
    this.id,
    this.ownerId,
    required this.account,
    required this.name,
    this.email,
    required this.password,
    this.url,
    required this.role,
    this.fcmToken
});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      ownerId: json['ownerId'],
        account: json['account']!,
        name: json['name']!,
        email: json['email'],
        password: json['password']!,
        url: json['url'],
        id: json['id'],
        role: json['roleId'],
        fcmToken: json['fcmToken']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['ownerId'] = ownerId;
    data['account'] = account;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    if (url != null) {
      data['url'] = url!;
    }
    data['roleId'] = role;
    if (fcmToken != null) {
      data['fcmToken'] = fcmToken;
    }
    return data;
  }
}