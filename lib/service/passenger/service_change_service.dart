

import 'package:tfleet/http/http.dart';

class ServiceChangeService {
  static const path = '/service_change/';

  static Future addChange(String serviceChange) async {
    final response = await Http.post(
        '${path}appSave',
        data: serviceChange
    );
    return response['code'];
  }

  static Future fetchChange(int userId, int childId) async {
    final response = await Http.get(
        '${path}appFetch/$userId/$childId',
    );
    return response['data'];
  }
}