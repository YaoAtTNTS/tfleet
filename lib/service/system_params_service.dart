
import 'package:tfleet/http/http.dart';

class SystemParamsService {

  static const path = '/parameter/';

  static Future getParams() async {
    final response = await Http.get(
        '${path}list',
    );
    return response['list'];
  }

  static Future getParam(String key) async {
    final response = await Http.get(
      '${path}info/$key',

    );
    return response['data'];
  }
}