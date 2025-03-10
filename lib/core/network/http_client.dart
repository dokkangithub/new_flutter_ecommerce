import 'package:dio/dio.dart';

// This class wraps the Dio client to allow for easier testing and mocking
class HttpClient {
  final Dio _dio;

  HttpClient({Dio? dio}) : _dio = dio ?? Dio();

  Future<Response> get(Uri url, {Map<String, String>? headers}) {
    return _dio.getUri(url, options: Options(headers: headers));
  }

  Future<Response> post(Uri url, {Map<String, String>? headers, Object? body}) {
    return _dio.postUri(url, data: body, options: Options(headers: headers));
  }

  Future<Response> put(Uri url, {Map<String, String>? headers, Object? body}) {
    return _dio.putUri(url, data: body, options: Options(headers: headers));
  }

  Future<Response> patch(Uri url, {Map<String, String>? headers, Object? body}) {
    return _dio.patchUri(url, data: body, options: Options(headers: headers));
  }

  Future<Response> delete(Uri url, {Map<String, String>? headers, Object? body}) {
    return _dio.deleteUri(url, data: body, options: Options(headers: headers));
  }

  void close() {
    _dio.close();
  }
}