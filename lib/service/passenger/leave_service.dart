

import 'dart:convert';

import 'package:tfleet/http/http.dart';
import 'package:tfleet/model/passenger/leave.dart';

class LeaveService {
  static const path = '/leave/';

  static Future getLeaves(Map<String, dynamic> params) async {
    final response = await Http.post(
        '${path}list',
        params: params
    );
    return response['list'];
  }

  static Future getLeave(int id) async {
    final response = await Http.get(
        '${path}info/$id'
    );
    return response['leave'];
  }

  static Future addLeave(Leave leave) async {
    final response = await Http.post(
        '${path}save',
        data: leave.toJson()
    );
    return response['code'];
  }

  static Future addRepeatableLeaves(String leaves) async {
    final response = await Http.post(
        '${path}web/save',
        data: leaves
    );
    return response;
  }

  static Future updateLeave(Map<String, dynamic> params) async {
    final response = await Http.post(
        '${path}update',
        params: params
    );
    return response['code'];
  }
  
}