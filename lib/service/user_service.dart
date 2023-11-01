

import 'package:tfleet/http/http.dart';
import 'package:tfleet/model/user.dart';
import 'package:tfleet/utils/global.dart';

class UserService {
  static const path = '/user/';

  static Future listUser(Map<String, String> params) async {
    final response = await Http.post(
        '${path}list',
      params: params
    );
    return response['list'];
  }

  static Future getUser(int id) async {
    final response = await Http.get(
        '${path}info/$id'
    );
    return response['data'];
  }

  static Future addUser(User user) async {
    final response = await Http.post(
        '${path}save',
        data: user.toJson()
    );
    if (response['msg'] == 'Mobile already existed.') {
      return 0;
    }
    if (response['msg'] == 'Second mobile already existed.') {
      return -1;
    }
    return response['data'];
  }

  static Future updateUser(Map<String, dynamic> params) async {
    final response = await Http.post(
        '${path}update',
        params: params
    );
    if (response['msg'] == 'Mobile already existed.') {
      return -2;
    }
    if (response['msg'] == 'Second mobile already existed.') {
      return -1;
    }
    return response['code'];
  }

  static Future deleteUser(int id) async {
    Map<String, dynamic> params = {};
    params['id'] = '$id';
    params['status'] = '-1';
    final response = await Http.post(
        '${path}update',
        params: params
    );
    return response['code'];
  }

  static Future saveFcmToken(String token) async {
    final response = await Http.post(
        '${path}save_fcm',
        params: {'id': Global.getUserId(), 'token': token}
    );
    return response['code'];
  }

  static Future changePassword(String oldPassword, String newPassword) async {
    final response = await Http.post(
        '${path}change_password',
      params: {'id': Global.getUserId(), 'oldPassword':oldPassword, 'newPassword':newPassword}
    );
    return response['msg'];
  }

  static Future resetPassword(String account) async {
    final response = await Http.post(
        '${path}reset_password',
        params: {'account': account}
    );
    return response;
  }

  static Future login(String clientId, String password) async {
    final Map<String, String> data = <String, String>{};
    data['account'] = clientId;
    data['password'] = password;
    final response = await Http.post(
        '${path}login',
      data: data
    );
    return response;
  }

  static Future logout(int id) async {
    final response = await Http.post(
        '${path}logout',
      data: id
    );
    return response['code'];
  }

  static Future getStaffs(Map<String, int>? params, int role) async {
    params ??= <String, int>{};
    params['ownerId'] = Global.getUserId()!;
    params['roleId'] = role;
    final response = await Http.post(
        '${path}staffs',
      params: params,
    );
    return response['list'];
  }


}