

import 'package:tfleet/http/http.dart';
import 'package:tfleet/utils/global.dart';

class TripService {

  static const path = '/trip/';

  static Future getActiveTrip() async {
    Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = Global.getUserId();
    params['role'] = Global.getRole();
    final response = await Http.post(
        '${path}active_trip',
        params: params
    );
    return response['trip'];
  }

  static Future getTrips({required Map<String, dynamic> params}) async {
    final response = await Http.post(
        '${path}list',
      params: params
    );
    return response['list'];
  }

  static Future getTripById(int id) async {
    final response = await Http.get(
        '${path}info/$id',
    );
    return response['trip'];
  }

  static Future updateTrip(Map<String, dynamic> params) async {
    print('=====================================');
    print(params['remaining']);
    final response = await Http.post(
        '${path}update',
      params: params
    );
    return response;
  }

  static Future updateOnboard(Map<String, dynamic> params) async {
    final response = await Http.post(
        '${path}update_onboard',
        params: params
    );
    return response;
  }

  static Future updateAlight(Map<String, dynamic> params) async {
    final response = await Http.post(
        '${path}update_alight',
        params: params
    );
    return response;
  }

  static Future updateAbsence(Map<String, dynamic> params) async {
    final response = await Http.post(
        '${path}update_absent',
        params: params
    );
    return response;
  }

  static Future deleteTrip(int id) async {
    final response = await Http.post(
        '${path}delete',
      data: id
    );
    return response;
  }

  static Future rejectTrip (int id) async {
    Map<String, dynamic> params = <String, dynamic>{};
    params['id'] = id;
    params['status'] = 0;
    params['ownerId'] = 0;
    params['rejection'][Global.getUserId()] = DateTime.now();
    final response = await Http.post(
        '${path}update',
      params: params
    );
    return response['data'];
  }

  static Future notifyDelay (int tripId, String ids, int type, int duration) async {
    Map<String, dynamic> params = <String, dynamic>{};
    params['tripId'] = tripId;
    params['ids'] = ids;
    params['duration'] = duration;
    params['type'] = type;
    final response = await Http.post(
        '${path}notify',
        params: params
    );
    return response;
  }

}