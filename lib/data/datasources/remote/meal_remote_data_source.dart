import '../../../core/network/rest_client.dart';
import '../../models/area/area_model.dart';
import '../../models/category/category_model.dart';
import '../../models/ingredient/ingredient_model.dart';
import '../../models/meal/filter_meal_model.dart';
import '../../models/meal/meal_detail_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealDetailModel>> searchMealsByName(String query);
  Future<List<MealDetailModel>> searchMealsByFirstLetter(String letter);
  Future<MealDetailModel> lookupMealById(String id);
  Future<MealDetailModel> getRandomMeal();
  Future<List<CategoryModel>> getCategories();
  Future<List<AreaModel>> getAreas();
  Future<List<IngredientModel>> getIngredients();
  Future<List<FilterMealModel>> filterByCategory(String category);
  Future<List<FilterMealModel>> filterByArea(String area);
  Future<List<FilterMealModel>> filterByIngredient(String ingredient);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  const MealRemoteDataSourceImpl(this._restClient);

  final RestClient _restClient;

  @override
  Future<List<MealDetailModel>> searchMealsByName(String query) async {
    final response = await _restClient.searchMealsByName(query);
    return response.meals ?? [];
  }

  @override
  Future<List<MealDetailModel>> searchMealsByFirstLetter(String letter) async {
    final response = await _restClient.searchMealsByFirstLetter(letter);
    return response.meals ?? [];
  }

  @override
  Future<MealDetailModel> lookupMealById(String id) async {
    final response = await _restClient.lookupMealById(id);
    final meals = response.meals;
    if (meals == null || meals.isEmpty) {
      throw Exception('Meal with ID $id not found.');
    }
    return meals.first;
  }

  @override
  Future<MealDetailModel> getRandomMeal() async {
    final response = await _restClient.getRandomMeal();
    final meals = response.meals;
    if (meals == null || meals.isEmpty) {
      throw Exception('No random meal available.');
    }
    return meals.first;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _restClient.getCategories();
    return response.categories ?? [];
  }

  @override
  Future<List<AreaModel>> getAreas() async {
    final response = await _restClient.getAreas('list');
    return response.meals ?? [];
  }

  @override
  Future<List<IngredientModel>> getIngredients() async {
    final response = await _restClient.getIngredients('list');
    return response.meals ?? [];
  }

  @override
  Future<List<FilterMealModel>> filterByCategory(String category) async {
    final response = await _restClient.filterByCategory(category);
    return response.meals ?? [];
  }

  @override
  Future<List<FilterMealModel>> filterByArea(String area) async {
    final response = await _restClient.filterByArea(area);
    return response.meals ?? [];
  }

  @override
  Future<List<FilterMealModel>> filterByIngredient(String ingredient) async {
    final response = await _restClient.filterByIngredient(ingredient);
    return response.meals ?? [];
  }
}
