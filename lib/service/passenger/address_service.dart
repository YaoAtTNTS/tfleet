


import 'package:tfleet/http/http.dart';
import 'package:tfleet/model/passenger/address.dart';

class AddressService {

  static const String path = '/address/';

  static Future getAddresses(int userId) async {
    final response = await Http.post(
      '${path}list',
      data: userId
    );
    return response['data'];
  }

  static Future getAddress(int id) async {
    final response = await Http.get(
        '${path}info/$id'
    );
    return response['address'];
  }

  static Future addAddress(Address address) async {
    final response = await Http.post(
        '${path}save',
        data: address.toJson()
    );
    return response['code'];
  }

  static Future updateAddress(Address address) async {
    final response = await Http.post(
        '${path}update',
        data: address.toJson()
    );
    return response['code'];
  }

  static Future deleteAddress(int id) async {
    final response = await Http.post(
        '${path}delete',
      data: id
    );
    return response['code'];
  }
}