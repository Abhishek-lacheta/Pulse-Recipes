import 'package:equatable/equatable.dart';
import '../../../data/models/meal/filter_meal_model.dart';

abstract class FilteredMealsState extends Equatable {
  const FilteredMealsState();

  @override
  List<Object?> get props => [];
}

class FilteredMealsInitial extends FilteredMealsState {
  const FilteredMealsInitial();
}

class FilteredMealsLoading extends FilteredMealsState {
  const FilteredMealsLoading();
}

class FilteredMealsSuccess extends FilteredMealsState {
  const FilteredMealsSuccess({
    required this.title,
    required this.meals,
  });

  final String title;
  final List<FilterMealModel> meals;

  @override
  List<Object?> get props => [title, meals];
}

class FilteredMealsEmpty extends FilteredMealsState {
  const FilteredMealsEmpty(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class FilteredMealsFailure extends FilteredMealsState {
  const FilteredMealsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
