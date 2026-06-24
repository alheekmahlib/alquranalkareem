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
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          validateStatus: (status) {
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
    String? fallbackUrl,
  }) async {
    try {
      final Map<String, String> finalHeaders = headers ?? {};
      if (token != null) {
        finalHeaders['Authorization'] = 'Bearer $token';
      }

      // log('Requesting $method $endpoint', name: 'ApiClient');
      print('Requesting $method $endpoint');
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
        // log('Response received: ${response.data}', name: 'ApiClient');
        log('Response received: ${response.data}', name: 'ApiClient');
      }
      return Right(response.data);
    } on DioException catch (e) {
      // log(
      log(
        'DioException occurred: ${e.message}, Status Code: ${e.response?.statusCode}',
        name: 'ApiClient',
      );

      // إذا فشل الطلب ووجد رابط بديل، حاول GitLab
      if (fallbackUrl != null) {
        return _requestFallback(fallbackUrl, method, headers);
      }

      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      // log('Unexpected error: $e', name: 'ApiClient');
      log('Unexpected error: $e', name: 'ApiClient');

      if (fallbackUrl != null) {
        return _requestFallback(fallbackUrl, method, headers);
      }

      return Left(DataSource.DEFAULT.getFailure());
    }
  }

  /// طلب بديل من GitLab عند فشل GitHub
  Future<Either<Failure, dynamic>> _requestFallback(
    String fallbackUrl,
    HttpMethod method,
    Map<String, String>? headers,
  ) async {
    try {
      // log('Trying fallback URL: $fallbackUrl', name: 'ApiClient');
      log('Trying fallback URL: $fallbackUrl', name: 'ApiClient');
      final response = await Dio().get(
        fallbackUrl,
        options: Options(headers: headers),
      );
      // log('Fallback request succeeded', name: 'ApiClient');
      log('Fallback request succeeded', name: 'ApiClient');
      return Right(response.data);
    } on DioException catch (e) {
      // log('Fallback also failed: ${e.message}', name: 'ApiClient');
      log('Fallback also failed: ${e.message}', name: 'ApiClient');
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      // log('Fallback error: $e', name: 'ApiClient');
      log('Fallback error: $e', name: 'ApiClient');
      return Left(DataSource.DEFAULT.getFailure());
    }
  }

  /// تحميل ملف من رابط خارجي مع تتبع التقدم ودعم الرابط البديل
  Future<Either<Failure, dynamic>> downloadFile({
    required String url,
    void Function(int received, int total)? onProgress,
    Duration? timeout,
    String? fallbackUrl,
  }) async {
    try {
      // log('Downloading from: $url', name: 'ApiClient');
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

      // log('Download completed', name: 'ApiClient');
      log('Download completed', name: 'ApiClient');
      return Right(response.data);
    } on DioException catch (e) {
      // log('Download failed: ${e.message}', name: 'ApiClient');
      log('Download failed: ${e.message}', name: 'ApiClient');

      // إذا فشل التحميل ووجد رابط بديل، حاول منه
      if (fallbackUrl != null) {
        return _downloadFallback(fallbackUrl, onProgress, timeout);
      }

      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      // log('Download error: $e', name: 'ApiClient');
      log('Download error: $e', name: 'ApiClient');

      if (fallbackUrl != null) {
        return _downloadFallback(fallbackUrl, onProgress, timeout);
      }

      return Left(DataSource.DEFAULT.getFailure());
    }
  }

  /// تحميل بديل من GitLab عند فشل GitHub
  Future<Either<Failure, dynamic>> _downloadFallback(
    String fallbackUrl,
    void Function(int, int)? onProgress,
    Duration? timeout,
  ) async {
    try {
      // log('Trying fallback download: $fallbackUrl', name: 'ApiClient');
      log('Trying fallback download: $fallbackUrl', name: 'ApiClient');
      final response = await Dio().get(
        fallbackUrl,
        options: Options(receiveTimeout: timeout ?? const Duration(minutes: 5)),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress?.call(received, total);
          }
        },
      );
      // log('Fallback download completed', name: 'ApiClient');
      log('Fallback download completed', name: 'ApiClient');
      return Right(response.data);
    } on DioException catch (e) {
      // log('Fallback download also failed: ${e.message}', name: 'ApiClient');
      log('Fallback download also failed: ${e.message}', name: 'ApiClient');
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      // log('Fallback download error: $e', name: 'ApiClient');
      log('Fallback download error: $e', name: 'ApiClient');
      return Left(DataSource.DEFAULT.getFailure());
    }
  }
}
