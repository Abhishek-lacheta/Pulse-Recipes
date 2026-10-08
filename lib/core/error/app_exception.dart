/// Custom application exceptions.
class AppException implements Exception {
  const AppException(this.message, {this.code, this.statusCode});

  final String message;
  final String? code;
  final int? statusCode;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection detected']);
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'Server error occurred',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Connection timed out']);
}

class ParsingException extends AppException {
  const ParsingException([super.message = 'Failed to parse server response']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}
