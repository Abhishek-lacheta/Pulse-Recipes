import '../../../core/utils/result.dart';
import '../models/area/area_model.dart';
import '../models/category/category_model.dart';
import '../models/ingredient/ingredient_model.dart';
import '../models/meal/filter_meal_model.dart';
import '../models/meal/meal_detail_model.dart';

/// Clean repository contract for Meal, Category, Area, and Ingredient operations.
abstract class MealRepository {
  Future<Result<List<MealDetailModel>>> searchMealsByName(String query);
  Future<Result<List<MealDetailModel>>> searchMealsByFirstLetter(String letter);
  Future<Result<MealDetailModel>> getMealDetails(String id);
  Future<Result<MealDetailModel>> getRandomMeal();
  Future<Result<List<CategoryModel>>> getCategories();
  Future<Result<List<AreaModel>>> getAreas();
  Future<Result<List<IngredientModel>>> getIngredients();
  Future<Result<List<FilterMealModel>>> filterByCategory(String category);
  Future<Result<List<FilterMealModel>>> filterByArea(String area);
  Future<Result<List<FilterMealModel>>> filterByIngredient(String ingredient);
}
