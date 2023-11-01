

import 'package:tfleet/http/http.dart';
import 'package:tfleet/model/passenger/child.dart';

class ChildService {
  static const path = '/student/';

  static Future getChildren(int userId) async {
    final response = await Http.post(
        '${path}list',
        data: userId
    );
    return response['data'];
  }

  static Future getChild(int id) async {
    final response = await Http.get(
        '${path}info/$id'
    );
    return response['child'];
  }

  static Future addChild(Child child) async {
    final response = await Http.post(
        '${path}save',
        data: child.toJson()
    );
    return response['data'];
  }

  static Future updateChild(Child child) async {
    final response = await Http.post(
        '${path}update',
        data: child.toJson()
    );
    return response['code'];
  }

  static Future deleteChild(int id) async {
    final response = await Http.post(
        '${path}delete',
      data: id
    );
    return response['code'];
  }
}