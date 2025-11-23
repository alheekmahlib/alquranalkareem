import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

import '../utils/constants/api_constants.dart';
import 'error_handling_system.dart';

enum HttpMethod { get, post, put, delete, patch, head, options }

class ApiClient {
  final Dio _dio;

  // إنشاء كائن Singleton
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl, // يمكنك تحديد baseUrl هنا
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

  Future<Either<Failure, dynamic>> request({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    String? token,
    Duration? connectTimeoutOverride,
    Duration? receiveTimeoutOverride,
    int retryCount = 0,
  }) async {
    final originalConnectTimeout = _dio.options.connectTimeout;
    final originalReceiveTimeout = _dio.options.receiveTimeout;
    try {
      final Map<String, String> finalHeaders = headers ?? {};
      if (token != null) {
        finalHeaders['Authorization'] = 'Bearer $token';
      }

      if (connectTimeoutOverride != null || receiveTimeoutOverride != null) {
        _dio.options = _dio.options.copyWith(
          connectTimeout: connectTimeoutOverride ?? originalConnectTimeout,
          receiveTimeout: receiveTimeoutOverride ?? originalReceiveTimeout,
        );
      }

      log(
        'Requesting $method $endpoint (retry=$retryCount)',
        name: 'ApiClient',
      );
      final Response response = await _dio.request(
        endpoint,
        options: Options(
          method: method.name.toUpperCase(),
          headers: finalHeaders,
          sendTimeout: connectTimeoutOverride,
          receiveTimeout: receiveTimeoutOverride,
        ),
        queryParameters: queryParameters,
        data: data,
      );

      // 404 => نعيد قائمة فارغة بدلاً من فشل (ملف JSON غير موجود أو فارغ على GitHub)
      if (response.statusCode == 404) {
        log('404 for $endpoint -> empty list returned', name: 'ApiClient');
        return const Right([]);
      }

      log('Response received: ${response.data}', name: 'ApiClient');
      return Right(response.data);
    } on DioException catch (e) {
      log('DioException occurred: ${e.message}', name: 'ApiClient');
      final type = e.type;
      final isTimeout =
          type == DioExceptionType.connectionTimeout ||
          type == DioExceptionType.receiveTimeout;
      if (isTimeout) {
        log(
          'Timeout details: connect=${_dio.options.connectTimeout} receive=${_dio.options.receiveTimeout}',
          name: 'ApiClient',
        );
        if (retryCount == 0) {
          log('Retrying with extended timeouts...', name: 'ApiClient');
          return request(
            endpoint: endpoint,
            method: method,
            queryParameters: queryParameters,
            data: data,
            headers: headers,
            token: token,
            connectTimeoutOverride: const Duration(seconds: 12),
            receiveTimeoutOverride: const Duration(seconds: 12),
            retryCount: 1,
          );
        }
      }
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      log('Unexpected error: $e', name: 'ApiClient');
      return Left(DataSource.DEFAULT.getFailure());
    } finally {
      if (connectTimeoutOverride != null || receiveTimeoutOverride != null) {
        _dio.options = _dio.options.copyWith(
          connectTimeout: originalConnectTimeout,
          receiveTimeout: originalReceiveTimeout,
        );
      }
    }
  }
}
