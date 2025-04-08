import 'dart:io';
import 'package:dio/dio.dart';
import 'package:laravel_ecommerce/core/api/api_exceptions.dart' show UserNotFoundException;
import 'package:laravel_ecommerce/core/utils/constants/app_strings.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker/talker.dart';
import '../config/app_config.dart/app_config.dart';
import '../errors/exceptions.dart';
import 'api_provider.dart';

class LaravelApiProvider implements ApiProvider {
  late final Dio _dio;
  final AppConfig _appConfig = AppConfig();
  String _languageCode = 'en';
  final Talker _talker = Talker();

  LaravelApiProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _appConfig.apiBaseUrl ?? '',
        connectTimeout: Duration(milliseconds: _appConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: _appConfig.receiveTimeout),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'System-Key': '123456',
            if (AppStrings.userId != null) 'Authorization': 'Bearer ${AppStrings.token}',
            'App-Language': 'en',
          }
      ),
    );

    // Replace PrettyDioLogger with TalkerDioLogger
    if (_appConfig.enableLogging) {
      _dio.interceptors.add(
        TalkerDioLogger(
          talker: _talker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printRequestData: true,
            printResponseHeaders: true,
            printResponseData: true,
            printResponseMessage: true,
          ),
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
      _talker.info('GET Request to: $endpoint');
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      final exception = _handleDioError(e);
      _talker.error('GET Request Error: ${exception.toString()}', exception);
      throw exception;
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
      _talker.info('POST Request to: $endpoint');
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      final exception = _handleDioError(e);
      _talker.error('POST Request Error: ${exception.toString()}', exception);
      throw exception;
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
      _talker.info('PUT Request to: $endpoint');
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      final exception = _handleDioError(e);
      _talker.error('PUT Request Error: ${exception.toString()}', exception);
      throw exception;
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
      _talker.info('DELETE Request to: $endpoint');
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      final exception = _handleDioError(e);
      _talker.error('DELETE Request Error: ${exception.toString()}', exception);
      throw exception;
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
      _talker.info('PATCH Request to: $endpoint');
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      final exception = _handleDioError(e);
      _talker.error('PATCH Request Error: ${exception.toString()}', exception);
      throw exception;
    }
  }

  @override
  void setAuthToken(String token) {
    _talker.debug('Setting auth token');
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void setLanguage(String languageCode) {
    _talker.debug('Setting language to: $languageCode');
    _languageCode = languageCode;
  }

  /// Handles Dio errors and throws appropriate exceptions
// lib/core/api/laravel_api_provider.dart

  Exception _handleDioError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          _talker.warning('Request timeout occurred', error);
          return const TimeoutException('Request timeout');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;

          _talker.error('Bad response: $statusCode', error);
          _talker.debug('Response data: $responseData');

          if (statusCode == 401) {
            // Check the response body for "User not found"
            final message = responseData is Map ? responseData['message'] : null;
            if (message == 'User not found') {
              return UserNotFoundException(message);
            }
            return const UnauthorizedException('Unauthorized');
          } else if (statusCode == 403) {
            return const ForbiddenException('Forbidden');
          } else if (statusCode == 404) {
            return const NotFoundException('Resource not found');
          } else if (statusCode == 422) {
            final errors = responseData is Map ? responseData['errors'] : null;
            return ValidationException(
              'Validation error',
              errors: errors is Map ? Map<String, dynamic>.from(errors) : null,
            );
          } else {
            final message = responseData is Map
                ? responseData['message'] ?? 'Server error'
                : 'Server error';
            return ServerException(message);
          }
        case DioExceptionType.cancel:
          _talker.info('Request cancelled', error);
          return const RequestCancelledException('Request cancelled');
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            _talker.warning('Network error: No internet connection', error);
            return const NetworkException('No internet connection');
          }
          _talker.error('Unknown error: ${error.message}', error);
          return ServerException(error.message ?? 'Unknown error');
        default:
          _talker.error('Server error: ${error.message}', error);
          return ServerException(error.message ?? 'Server error');
      }
    } else if (error is SocketException) {
      _talker.warning('Socket exception: No internet connection', error);
      return const NetworkException('No internet connection');
    } else {
      _talker.error('Unexpected error type: ${error.toString()}', error);
      return ServerException(error.toString());
    }
  }
  // Getter to expose the talker instance for external use
  Talker get talker => _talker;
}