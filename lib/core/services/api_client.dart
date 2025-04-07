import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

import '../utils/constants/api_constants.dart';
import 'error_handling_system.dart';

enum HttpMethod {
  get,
  post,
  put,
  delete,
  patch,
  head,
  options,
}

class ApiClient {
  final Dio _dio;

  // إنشاء كائن Singleton
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl, // يمكنك تحديد baseUrl هنا
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ));

  Future<Either<Failure, dynamic>> request({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
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
        options: Options(
          method: method.name.toUpperCase(),
          headers: finalHeaders,
        ),
        queryParameters: queryParameters,
        data: data,
      );

      log('Response received: ${response.data}', name: 'ApiClient');
      return Right(response.data);
    } on DioException catch (e) {
      // تسجيل الأخطاء المتعلقة بـ Dio
      // Log Dio-related errors
      log('DioException occurred: ${e.message}', name: 'ApiClient');
      return Left(ErrorHandler.handle(e).failure);
    } catch (e) {
      // تسجيل أي استثناء عام
      // Log any general exception
      log('Unexpected error: $e', name: 'ApiClient');
      return Left(DataSource.DEFAULT.getFailure());
    }
  }
}
