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
          validateStatus: (status) {
            // السماح بمعالجة جميع الأكواد بما في ذلك 404
            // Allow handling all status codes including 404
            return status != null && status < 500;
          },
        ),
      );

  Future<Either<Failure, dynamic>> request({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Options? options,
    bool? printResponse = false,
    void Function(int, int)? onReceiveProgress,
    String? token,
  }) async {
    try {
      final Map<String, String> finalHeaders = headers ?? {};
      if (token != null) {
        finalHeaders['Authorization'] = 'Bearer $token';
      }

      log('Requesting $method $endpoint', name: 'ApiClient');
      final Response response = await _dio.request(
        endpoint,
        options:
            options ??
            Options(method: method.name.toUpperCase(), headers: finalHeaders),
        queryParameters: queryParameters,
        data: data,
        onReceiveProgress: onReceiveProgress,
      );

      if (printResponse!) {
        log('Response received: ${response.data}', name: 'ApiClient');
      }
      return Right(response.data);
    } on DioException catch (e) {
      // تسجيل الأخطاء المتعلقة بـ Dio
      // Log Dio-related errors
      log(
        'DioException occurred: ${e.message}, Status Code: ${e.response?.statusCode}',
        name: 'ApiClient',
      );
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      // تسجيل أي استثناء عام
      // Log any general exception
      log('Unexpected error: $e', name: 'ApiClient');
      return Left(DataSource.DEFAULT.getFailure());
    }
  }

  /// تحميل ملف من رابط خارجي مع تتبع التقدم
  /// Download file from external URL with progress tracking
  Future<Either<Failure, dynamic>> downloadFile({
    required String url,
    void Function(int received, int total)? onProgress,
    Duration? timeout,
  }) async {
    try {
      log('Downloading from: $url', name: 'ApiClient');

      final response = await Dio().get(
        url,
        options: Options(receiveTimeout: timeout ?? const Duration(minutes: 5)),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress?.call(received, total);
          }
        },
      );

      log('Download completed', name: 'ApiClient');
      return Right(response.data);
    } on DioException catch (e) {
      log('Download failed: ${e.message}', name: 'ApiClient');
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      log('Download error: $e', name: 'ApiClient');
      return Left(DataSource.DEFAULT.getFailure());
    }
  }
}
