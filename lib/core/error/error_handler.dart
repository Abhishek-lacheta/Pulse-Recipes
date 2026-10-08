import 'package:dio/dio.dart';
import 'app_exception.dart';
import 'failure.dart';

/// Maps Dio and standard exceptions into strongly typed [AppFailure] objects.
class ErrorHandler {
  ErrorHandler._();

  static AppFailure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    } else if (error is AppException) {
      return _handleAppException(error);
    } else if (error is TypeError || error is FormatException) {
      return const AppFailure(
        message: 'Data parsing error occurred. Please try again.',
        type: FailureType.parsing,
      );
    } else {
      return AppFailure(
        message: error?.toString() ?? 'An unexpected error occurred.',
        type: FailureType.unknown,
      );
    }
  }

  static AppFailure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppFailure(
          message: 'Connection timed out. Please check your internet connection.',
          type: FailureType.timeout,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return const AppFailure(
            message: 'Requested meal or resource was not found.',
            type: FailureType.notFound,
            statusCode: 404,
          );
        }
        return AppFailure(
          message: 'Server responded with error: ${statusCode ?? "unknown"}.',
          type: FailureType.server,
          statusCode: statusCode,
        );

      case DioExceptionType.connectionError:
        return const AppFailure(
          message: 'Unable to connect to TheMealDB server. Check your network.',
          type: FailureType.network,
        );

      case DioExceptionType.cancel:
        return const AppFailure(
          message: 'Request was cancelled.',
          type: FailureType.unknown,
        );

      case DioExceptionType.badCertificate:
        return const AppFailure(
          message: 'Security certificate validation failed.',
          type: FailureType.server,
        );

      case DioExceptionType.unknown:
      default:
        return const AppFailure(
          message: 'Internet connection error or network unavailable.',
          type: FailureType.network,
        );
    }
  }

  static AppFailure _handleAppException(AppException exception) {
    if (exception is NetworkException) {
      return AppFailure(message: exception.message, type: FailureType.network);
    } else if (exception is TimeoutException) {
      return AppFailure(message: exception.message, type: FailureType.timeout);
    } else if (exception is ServerException) {
      return AppFailure(
        message: exception.message,
        type: FailureType.server,
        statusCode: exception.statusCode,
      );
    } else if (exception is ParsingException) {
      return AppFailure(message: exception.message, type: FailureType.parsing);
    } else if (exception is NotFoundException) {
      return AppFailure(message: exception.message, type: FailureType.notFound);
    }
    return AppFailure(message: exception.message, type: FailureType.unknown);
  }
}
