import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../config/app_config.dart/app_config.dart';
import '../errors/exceptions.dart';
import 'api_provider.dart';

class LaravelApiProvider implements ApiProvider {
  late final Dio _dio;
  final AppConfig _appConfig = AppConfig();
  String _languageCode = 'en';

  LaravelApiProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _appConfig.apiBaseUrl ?? '',
        connectTimeout: Duration(milliseconds: _appConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: _appConfig.receiveTimeout),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'System-Key': '123456'
        },
      ),
    );

    // Logging Interceptor (Only in Development Mode)
    if (_appConfig.enableLogging) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          // Set to false for expanded logs
          maxWidth: 90, // Adjust log width
        ),
      );
    }

    // Language Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Accept-Language'] = _languageCode;
          return handler.next(options);
        },
      ),
    );
  }

  @override
  String get baseUrl => _appConfig.apiBaseUrl ?? '';

  @override
  Future<Response<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Response<dynamic>> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Response<dynamic>> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Response<dynamic>> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Response<dynamic>> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void setLanguage(String languageCode) {
    _languageCode = languageCode;
  }

  /// Handles Dio errors and throws appropriate exceptions
  Exception _handleDioError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const TimeoutException('Request timeout');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;

          if (statusCode == 401) {
            return const UnauthorizedException('Unauthorized');
          } else if (statusCode == 403) {
            return const ForbiddenException('Forbidden');
          } else if (statusCode == 404) {
            return const NotFoundException('Resource not found');
          } else if (statusCode == 422) {
            // Handle validation errors
            final errors = responseData is Map ? responseData['errors'] : null;
            return ValidationException(
              'Validation error',
              errors: errors is Map ? Map<String, dynamic>.from(errors) : null,
            );
          } else {
            final message =
                responseData is Map
                    ? responseData['message'] ?? 'Server error'
                    : 'Server error';
            return ServerException(message);
          }
        case DioExceptionType.cancel:
          return const RequestCancelledException('Request cancelled');
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return const NetworkException('No internet connection');
          }
          return ServerException(error.message ?? 'Unknown error');
        default:
          return ServerException(error.message ?? 'Server error');
      }
    } else if (error is SocketException) {
      return const NetworkException('No internet connection');
    } else {
      return ServerException(error.toString());
    }
  }
}
