

import 'package:tfleet/http/http.dart';

class FilesService {

  static const path = '/files/';

  static Future getFiles({required Map<String, dynamic> params}) async {
    final response = await Http.post(
        '${path}list',
        params: params
    );
    return response['list'];
  }

  static Future deleteFiles(int id) async {
    final response = await Http.post(
        '${path}delete',
      data: id
    );
    return response['data'];
  }

  static Future readFiles(int id) async {
    final response = await Http.post(
        '${path}read',
        data: id
    );
    return response['data'];
  }


}