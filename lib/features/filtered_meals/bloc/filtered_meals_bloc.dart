import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/result.dart';
import '../../../data/models/meal/filter_meal_model.dart';
import '../../../data/repositories/meal_repository.dart';
import 'filtered_meals_event.dart';
import 'filtered_meals_state.dart';

export 'filtered_meals_event.dart';
export 'filtered_meals_state.dart';

class FilteredMealsBloc extends Bloc<FilteredMealsEvent, FilteredMealsState> {
  FilteredMealsBloc(this._mealRepository) : super(const FilteredMealsInitial()) {
    on<FilteredMealsFetchEvent>(_onFetch);
  }

  final MealRepository _mealRepository;

  Future<void> _onFetch(
    FilteredMealsFetchEvent event,
    Emitter<FilteredMealsState> emit,
  ) async {
    emit(const FilteredMealsLoading());

    late final Result<List<FilterMealModel>> result;
    late final String title;

    if (event.category != null) {
      title = event.category!;
      result = await _mealRepository.filterByCategory(event.category!);
    } else if (event.area != null) {
      title = '${event.area} Cuisine';
      result = await _mealRepository.filterByArea(event.area!);
    } else if (event.ingredient != null) {
      title = event.ingredient!;
      result = await _mealRepository.filterByIngredient(event.ingredient!);
    } else {
      emit(const FilteredMealsFailure('No filter criteria specified.'));
      return;
    }

    if (result.isSuccess) {
      final meals = result.data ?? [];
      if (meals.isEmpty) {
        emit(FilteredMealsEmpty(title));
      } else {
        emit(FilteredMealsSuccess(title: title, meals: meals));
      }
    } else {
      emit(FilteredMealsFailure(result.failure!.message));
    }
  }
}
