import 'package:dio/dio.dart';
import 'http_request.dart';

class Http {
  /// 初始化公共属性
  /// 如果需要覆盖原配置项 就调用它
  static void init({
    required String baseUrl,
    required int connectTimeout,
    required int receiveTimeout,
    required Map<String, dynamic> headers,
    required List<Interceptor> interceptors,
  }) {
    HttpRequest().init(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: headers,
      interceptors: interceptors,
    );
  }

  /// 设置请求头
  static void setHeaders(Map<String, dynamic> headers) {
    HttpRequest().setHeaders(headers);
  }

  /// 取消请求
  static void cancelRequests({required CancelToken token}) {
    HttpRequest().cancelRequests(token: token);
  }

  /// restful get 操作
  static Future get(
      String path, {
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    return await HttpRequest().get(
      path,
      params: params,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// restful post 操作
  static Future post(
      String path, {
        Map<String, dynamic>? params,
        dynamic data,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    return await HttpRequest().post(
      path,
      params: params,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// restful get 操作
  static Future delete(
      String path, {
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    return await HttpRequest().delete(
      path,
      params: params,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// restful post form 表单提交操作
  static Future postForm(
      String path, {
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    return await HttpRequest().postForm(
      path,
      params: params,
      options: options,
      cancelToken: cancelToken,
    );
  }
}