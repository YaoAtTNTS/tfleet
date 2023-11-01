

import 'package:tfleet/http/http.dart';

class AbsenceService {

  static Future getDriverAbsences(int id) async {
    final response = await Http.get(
        '/driver/absence/all/$id',
    );
    return response['list'];
  }

  static Future getAttendanceAbsences(int id) async {
    final response = await Http.get(
      '/attendant/absence/all/$id',
    );
    return response['list'];
  }

}