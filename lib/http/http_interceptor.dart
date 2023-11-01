import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'http_exception.dart';

class HttpInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) async {
    if (response.data is String) {
      super.onResponse(response, handler);
    } else {
      Map<String, dynamic> data = response.data;
      if (data['code'] != 0) {
        HttpException httpException = HttpException(
          code: data['code'],
          msg: data['msg'],
        );
        throw httpException;
      } else {
        super.onResponse(response, handler);
      }
    }
  }

  @override
  Future onError(
      DioError err,
      ErrorInterceptorHandler handler,
      ) async {

    HttpException httpException = HttpException.create(err);

    debugPrint('DioError===: ${httpException.toString()}');
    err.error = httpException;
    super.onError(err, handler);
  }
}