

import 'package:tfleet/http/http.dart';

class FileService {
  static const path = '/file/';

  static Future delete(String fileName) async {
    final response = await Http.post(
        '${path}delete',
        data: fileName
    );
    return response;
  }
}