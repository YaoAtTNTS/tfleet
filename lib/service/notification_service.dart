

import 'package:tfleet/http/http.dart';

class NotificationService {

  static const String path = '/notification/';

  static Future getNotifications(int userId) async {
    final response = await Http.post(
        '${path}list',
        data: userId
    );
    return response['list'];
  }

  static Future read(int id) async {
    final response = await Http.get(
        '${path}read/$id',
    );
    return response;
  }
}