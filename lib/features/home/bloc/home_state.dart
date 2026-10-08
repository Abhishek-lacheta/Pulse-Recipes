import 'package:equatable/equatable.dart';
import '../../../data/models/area/area_model.dart';
import '../../../data/models/category/category_model.dart';
import '../../../data/models/meal/filter_meal_model.dart';
import '../../../data/models/meal/meal_detail_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeSuccess extends HomeState {
  const HomeSuccess({
    required this.featuredMeal,
    required this.categories,
    required this.popularMeals,
    required this.areas,
  });

  final MealDetailModel featuredMeal;
  final List<CategoryModel> categories;
  final List<FilterMealModel> popularMeals;
  final List<AreaModel> areas;

  @override
  List<Object?> get props => [featuredMeal, categories, popularMeals, areas];
}

class HomeFailure extends HomeState {
  const HomeFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
