import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/ingredient/ingredient_model.dart';
import '../../../data/repositories/meal_repository.dart';
import 'ingredients_event.dart';
import 'ingredients_state.dart';

export 'ingredients_event.dart';
export 'ingredients_state.dart';

class IngredientsBloc extends Bloc<IngredientsEvent, IngredientsState> {
  IngredientsBloc(this._mealRepository) : super(const IngredientsInitial()) {
    on<IngredientsFetchEvent>(_onFetch);
    on<IngredientsFilterQueryEvent>(_onFilterQuery);
  }

  final MealRepository _mealRepository;
  List<IngredientModel> _cached = [];

  Future<void> _onFetch(
    IngredientsFetchEvent event,
    Emitter<IngredientsState> emit,
  ) async {
    emit(const IngredientsLoading());
    final result = await _mealRepository.getIngredients();
    if (result.isSuccess) {
      _cached = result.data ?? [];
      emit(
        IngredientsSuccess(
          allIngredients: _cached,
          filteredIngredients: _cached,
        ),
      );
    } else {
      emit(IngredientsFailure(result.failure!.message));
    }
  }

  void _onFilterQuery(
    IngredientsFilterQueryEvent event,
    Emitter<IngredientsState> emit,
  ) {
    final query = event.query.toLowerCase().trim();
    if (query.isEmpty) {
      emit(
        IngredientsSuccess(
          allIngredients: _cached,
          filteredIngredients: _cached,
          searchQuery: '',
        ),
      );
    } else {
      final filtered = _cached
          .where((i) => i.strIngredient.toLowerCase().contains(query))
          .toList();
      emit(
        IngredientsSuccess(
          allIngredients: _cached,
          filteredIngredients: filtered,
          searchQuery: event.query,
        ),
      );
    }
  }
}
