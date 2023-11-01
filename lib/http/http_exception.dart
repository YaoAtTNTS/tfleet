import 'package:dio/dio.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/utils/toast.dart';

class HttpException implements Exception {
  final int code;
  final String msg;

  HttpException({this.code = 500, this.msg = 'Unknown error.'});

  String toString() {
    return "HttpError [$code]: $msg";
  }
  factory HttpException.create(DioError error) {
    // dio error
    switch (error.type) {
      case DioErrorType.cancel:
        return HttpException(code: -1, msg: 'Request cancelled.');
        break;
      case DioErrorType.connectTimeout:
        return HttpException(code: -1, msg: 'Connection timeout.');
        break;
      case DioErrorType.sendTimeout:
        return HttpException(code: -1, msg: 'Request timeout.');
        break;
      case DioErrorType.receiveTimeout:
        return HttpException(code: -1, msg: 'Response timeout.');
        break;
      case DioErrorType.response:
      // server error
        int statusCode = error.response!.statusCode!;
        switch (statusCode) {
          case 400:
            return HttpException(code: statusCode, msg: 'Syntax error.');
            break;
          case 401:
            return HttpException(code: statusCode, msg: 'Permission denied.');
            break;
          case 403:
            return HttpException(code: statusCode, msg: 'Connection refused.');
            break;
          case 404:
            return HttpException(code: statusCode, msg: 'Not found.');
            break;
          case 500:
            return HttpException(code: statusCode, msg: 'Server internal error.');
            break;
          case 502:
            return HttpException(code: statusCode, msg: 'Invalid request.');
            break;
          case 503:
            return HttpException(code: statusCode, msg: 'Server down.');
            break;
          case 505:
            return HttpException(code: statusCode, msg: 'Http not supported.');
            break;
          default:
            return HttpException(
              code: statusCode,
              msg: error.response!.statusMessage!,
            );
        }
        break;
      default:
        if (error.message.contains('Network is unreachable')) {
          if (navigatorKey.currentState?.context != null) {
            Toast.toast(navigatorKey.currentState!.context, msg: AppLocalizations.of(navigatorKey.currentState!.context)?.networkIssue ?? 'Network connection issue',position: ToastPostion.center);
          }
        }
        return HttpException(code: 500, msg: error.message);
    }
  }
}