

import 'dart:convert';

import 'package:tfleet/http/http.dart';
import 'package:tfleet/model/subcon/vehicle.dart';
import 'package:tfleet/utils/global.dart';

class VehicleService {
  static const path = '/vehicle/';

  static Future getVehicles(Map<String, dynamic>? params) async {
    params ??= <String, dynamic>{};
    params['ownerId'] = Global.getUserId();
    final response = await Http.post(
      '${path}list',
      params: params,
    );
    return response['list'];
  }

  static Future getVehicle(int id) async {
    final response = await Http.get(
        '${path}info/$id'
    );
    return jsonDecode(response)['data'];
  }

  static Future addVehicle(Vehicle vehicle) async {
    final response = await Http.post(
        '${path}app/save',
        data: vehicle.toJson()
    );
    if (response['msg'] == 'Vehicle already existed.') {
      return '0';
    }
    return response['data'];
  }

  static Future updateVehicle(Vehicle vehicle) async {
    final response = await Http.post(
        '${path}update',
        data: jsonEncode(vehicle)
    );
    return jsonDecode(response)['code'];
  }

  static Future deleteVehicle(int id) async {
    final response = await Http.get(
        '${path}delete/$id',
    );
    var decoded = jsonDecode(response);
    return decoded['code'];
  }
}