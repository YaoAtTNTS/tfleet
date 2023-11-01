

import 'package:tfleet/http/http.dart';
import 'package:tfleet/model/driver/gps_data.dart';

class GpsService {

  static const path = '/gps/';

  static Future uploadGpsData(GpsData data) async {
    final response = await Http.post(
        '${path}upload',
        data: data
    );
    return response;
  }

}