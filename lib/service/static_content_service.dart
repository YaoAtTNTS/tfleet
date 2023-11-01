

import 'package:tfleet/http/http.dart';

class StaticContentService {

  static const String path = '/static_content/';

  static Future getContent(int contentId) async {
    final response = await Http.get(
        '${path}one/$contentId',
    );
    return response['data']['content'];
  }
}