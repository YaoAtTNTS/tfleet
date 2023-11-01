

import 'package:tfleet/http/http.dart';

class SchoolService {

  static const String path = '/school/';

  static Future getSchools() async {
    final response = await Http.post(
        '${path}list',
        params: {}
    );
    return response['list'];
  }
}