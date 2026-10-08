/// Centralized API constants for TheMealDB non-premium endpoints.
class ApiConstants {
  ApiConstants._();

  /// Base URL for TheMealDB free tier API (key '1')
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  // Endpoint paths
  static const String searchMeal = 'search.php';
  static const String lookupMeal = 'lookup.php';
  static const String randomMeal = 'random.php';
  static const String categories = 'categories.php';
  static const String list = 'list.php';
  static const String filter = 'filter.php';

  // Query parameter names
  static const String paramSearch = 's';
  static const String paramFirstLetter = 'f';
  static const String paramId = 'i';
  static const String paramCategory = 'c';
  static const String paramArea = 'a';
  static const String paramIngredient = 'i';
  static const String paramListType = 'list';

  // Image helpers
  static String ingredientImageUrl(String ingredientName) {
    return 'https://www.themealdb.com/images/ingredients/${Uri.encodeComponent(ingredientName)}.png';
  }

  static String ingredientSmallImageUrl(String ingredientName) {
    return 'https://www.themealdb.com/images/ingredients/${Uri.encodeComponent(ingredientName)}-Small.png';
  }
}
