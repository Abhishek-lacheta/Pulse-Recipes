import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Formatted, structured Dio Interceptor adhering to requirements.
/// Sanitizes sensitive fields and automatically silences in release mode.
class AppLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
      sanitizedHeaders.removeWhere((k, _) =>
          k.toLowerCase().contains('authorization') ||
          k.toLowerCase().contains('password') ||
          k.toLowerCase().contains('token'));

      debugPrint('════════════════════════════════════');
      debugPrint('REQUEST');
      debugPrint('════════════════════════════════════');
      debugPrint('METHOD: ${options.method}');
      debugPrint('URL: ${options.uri}');
      debugPrint('QUERY PARAMETERS: ${options.queryParameters}');
      debugPrint('HEADERS: $sanitizedHeaders');
      if (options.data != null) {
        debugPrint('BODY: ${options.data}');
      }
      debugPrint('');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('════════════════════════════════════');
      debugPrint('RESPONSE');
      debugPrint('════════════════════════════════════');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('URL: ${response.requestOptions.uri}');
      final responsePreview = response.data.toString();
      final displayData = responsePreview.length > 500
          ? '${responsePreview.substring(0, 500)}... [truncated]'
          : responsePreview;
      debugPrint('RESPONSE DATA: $displayData');
      debugPrint('');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('════════════════════════════════════');
      debugPrint('ERROR');
      debugPrint('════════════════════════════════════');
      debugPrint('STATUS CODE: ${err.response?.statusCode}');
      debugPrint('URL: ${err.requestOptions.uri}');
      debugPrint('MESSAGE: ${err.message}');
      debugPrint('ERROR TYPE: ${err.type}');
      debugPrint('');
    }
    super.onError(err, handler);
  }
}
