// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';

class Failure {
  final String message;
  final int code;

  Failure(this.code, this.message);
}

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else {
      failure = DataSource.DEFAULT.getFailure();
    }
  }

  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.RECIEVE_TIMEOUT.getFailure();
      case DioExceptionType.badResponse:
        if (error.response != null && error.response?.statusCode != null) {
          switch (error.response?.statusCode) {
            case ResponseCode.BAD_REQUEST:
              return DataSource.BAD_REQUEST.getFailure();
            case ResponseCode.UNAUTORISED:
              return DataSource.UNAUTORISED.getFailure();
            case ResponseCode.FORBIDDEN:
              return DataSource.FORBIDDEN.getFailure();
            case ResponseCode.NOT_FOUND:
              return DataSource.NOT_FOUND.getFailure();
            case ResponseCode.INTERNAL_SERVER_ERROR:
              return DataSource.INTERNAL_SERVER_ERROR.getFailure();
            default:
              return Failure(
                error.response?.statusCode ?? 0,
                error.response?.statusMessage ?? "Unknown error",
              );
          }
        } else {
          return DataSource.DEFAULT.getFailure();
        }
      case DioExceptionType.cancel:
        return DataSource.CANCEL.getFailure();
      case DioExceptionType.unknown:
        return DataSource.DEFAULT.getFailure();
      case DioExceptionType.badCertificate:
        return Failure(501, "Unknown resource with this certificate");
      case DioExceptionType.connectionError:
        return Failure(500, "Internal Server Error");
    }
  }
}

enum DataSource {
  BAD_REQUEST,
  UNAUTORISED,
  FORBIDDEN,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  SEND_TIMEOUT,
  RECIEVE_TIMEOUT,
  CANCEL,
  DEFAULT,
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED);
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR,
            ResponseMessage.INTERNAL_SERVER_ERROR);
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
            ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
            ResponseCode.RECIEVE_TIMEOUT, ResponseMessage.RECIEVE_TIMEOUT);
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
      default:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }
}

class ResponseCode {
  static const int BAD_REQUEST = 400;
  static const int UNAUTORISED = 401;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int CONNECT_TIMEOUT = -1;
  static const int SEND_TIMEOUT = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int CANCEL = -4;
  static const int DEFAULT = -5;
}

class ResponseMessage {
  static const String BAD_REQUEST = "Bad request error";
  static const String UNAUTORISED = "Unauthorized error";
  static const String FORBIDDEN = "Forbidden error";
  static const String NOT_FOUND = "Not found error";
  static const String INTERNAL_SERVER_ERROR = "Internal server error";
  static const String CONNECT_TIMEOUT = "Connection timeout error";
  static const String SEND_TIMEOUT = "Send timeout error";
  static const String RECIEVE_TIMEOUT = "Receive timeout error";
  static const String CANCEL = "Request was cancelled";
  static const String DEFAULT = "An unknown error occurred";
}
