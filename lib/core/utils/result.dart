import '../error/failure.dart';

/// A type-safe container representing either a successful [data] result or a [failure].
class Result<T> {
  const Result._({this.data, this.failure, required this.isSuccess});

  final T? data;
  final AppFailure? failure;
  final bool isSuccess;

  bool get isFailure => !isSuccess;

  factory Result.success(T data) {
    return Result._(data: data, isSuccess: true);
  }

  factory Result.failure(AppFailure failure) {
    return Result._(failure: failure, isSuccess: false);
  }

  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) {
    if (isSuccess && data != null) {
      return success(data as T);
    } else {
      return failure(this.failure ?? const AppFailure(message: 'Unknown error'));
    }
  }
}
