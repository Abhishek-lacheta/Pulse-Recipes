import 'package:equatable/equatable.dart';

/// Categorization of failure types.
enum FailureType {
  network,
  timeout,
  server,
  parsing,
  notFound,
  unknown,
}

/// User-friendly error representation used by BLoC and UI.
class AppFailure extends Equatable {
  const AppFailure({
    required this.message,
    this.type = FailureType.unknown,
    this.statusCode,
  });

  final String message;
  final FailureType type;
  final int? statusCode;

  @override
  List<Object?> get props => [message, type, statusCode];

  @override
  String toString() => message;
}
