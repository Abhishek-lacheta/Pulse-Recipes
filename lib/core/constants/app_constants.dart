/// Application-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Pulse Recipes';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  static const int searchDebounceMs = 500;
}
