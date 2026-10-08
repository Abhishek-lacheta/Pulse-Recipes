import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/area/area_model.dart';
import '../../data/models/category/category_model.dart';
import '../../data/models/ingredient/ingredient_model.dart';
import '../../data/models/meal/filter_meal_model.dart';
import '../../data/models/meal/meal_detail_model.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('search.php')
  Future<MealDetailResponse> searchMealsByName(@Query('s') String query);

  @GET('search.php')
  Future<MealDetailResponse> searchMealsByFirstLetter(@Query('f') String letter);

  @GET('lookup.php')
  Future<MealDetailResponse> lookupMealById(@Query('i') String id);

  @GET('random.php')
  Future<MealDetailResponse> getRandomMeal();

  @GET('categories.php')
  Future<CategoryResponse> getCategories();

  @GET('list.php')
  Future<AreaResponse> getAreas(@Query('a') String type);

  @GET('list.php')
  Future<IngredientResponse> getIngredients(@Query('i') String type);

  @GET('filter.php')
  Future<FilterMealResponse> filterByCategory(@Query('c') String category);

  @GET('filter.php')
  Future<FilterMealResponse> filterByArea(@Query('a') String area);

  @GET('filter.php')
  Future<FilterMealResponse> filterByIngredient(@Query('i') String ingredient);
}
