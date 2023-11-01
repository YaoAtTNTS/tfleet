

class Notification {
  
  final int id;
  final String notificationId;
  final int userId;
  final String title;
  final String content;
  final DateTime? time;
  int status;
  
  Notification({
   required this.id,
    required this.notificationId,
    required this.userId,
   required this.title,
   required this.content,
   required this.time,
   required this.status 
});
  
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
        id: json['id'],
        notificationId: json['notificationId'],
        userId: json['userId'],
        title: json['title'],
        content: json['content'],
        time: json['time'] != null ? DateTime.parse(json['time']) : null,
        status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['notificationId'] = notificationId;
    json['userId'] = userId;
    json['title'] = title;
    json['content'] = content;
    json['time'] = time?.toString();
    json['status'] = status;
    return json;
  }
}