import '../../../core/error/error_handler.dart';
import '../../../core/utils/result.dart';
import '../datasources/remote/meal_remote_data_source.dart';
import '../models/area/area_model.dart';
import '../models/category/category_model.dart';
import '../models/ingredient/ingredient_model.dart';
import '../models/meal/filter_meal_model.dart';
import '../models/meal/meal_detail_model.dart';
import 'meal_repository.dart';

class MealRepositoryImpl implements MealRepository {
  const MealRepositoryImpl(this._remoteDataSource);

  final MealRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<MealDetailModel>>> searchMealsByName(String query) async {
    try {
      final meals = await _remoteDataSource.searchMealsByName(query);
      return Result.success(meals);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<MealDetailModel>>> searchMealsByFirstLetter(String letter) async {
    try {
      final meals = await _remoteDataSource.searchMealsByFirstLetter(letter);
      return Result.success(meals);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<MealDetailModel>> getMealDetails(String id) async {
    try {
      final meal = await _remoteDataSource.lookupMealById(id);
      return Result.success(meal);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<MealDetailModel>> getRandomMeal() async {
    try {
      final meal = await _remoteDataSource.getRandomMeal();
      return Result.success(meal);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<CategoryModel>>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      return Result.success(categories);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<AreaModel>>> getAreas() async {
    try {
      final areas = await _remoteDataSource.getAreas();
      return Result.success(areas);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<IngredientModel>>> getIngredients() async {
    try {
      final ingredients = await _remoteDataSource.getIngredients();
      return Result.success(ingredients);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<FilterMealModel>>> filterByCategory(String category) async {
    try {
      final meals = await _remoteDataSource.filterByCategory(category);
      return Result.success(meals);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<FilterMealModel>>> filterByArea(String area) async {
    try {
      final meals = await _remoteDataSource.filterByArea(area);
      return Result.success(meals);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<FilterMealModel>>> filterByIngredient(String ingredient) async {
    try {
      final meals = await _remoteDataSource.filterByIngredient(ingredient);
      return Result.success(meals);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e));
    }
  }
}
