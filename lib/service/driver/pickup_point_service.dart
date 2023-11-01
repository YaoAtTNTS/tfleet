

import 'package:tfleet/http/http.dart';

class PickupPointService {

  static const path = '/pickuppoint/';

  static Future getPickupPoints(int routeId) async {
    final response = await Http.get(
        '${path}list/$routeId',
    );
    return response['data'];
  }

  static Future getPickupPoint(int ppId) async {
    final response = await Http.get(
      '${path}info/$ppId',
    );
    return response['pickuppoint'];
  }
}