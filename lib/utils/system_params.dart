

import 'package:tfleet/service/system_params_service.dart';

class SystemParams {

  SystemParams._();

  static final SystemParams _instance = SystemParams._();

  static SystemParams get instance => _instance;

  static final Map<String, dynamic> _params = {};

  bool _isAvailable = true;

  Future init() async {
    if (_isAvailable) {
      _isAvailable = false;
      // var rawParams = await SystemParamsService.getParams();
      // for (Map<String, dynamic> e in rawParams) {
      //   _params[e['key']] = _params[e['value']];
      // }
    }

  }

  int? get(String key) {
    if (_params.containsKey(key)) {
      return _params[key];
    }
    return null;
  }
}