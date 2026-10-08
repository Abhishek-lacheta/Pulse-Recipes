import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../data/repositories/meal_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

export 'search_event.dart';
export 'search_state.dart';

EventTransformer<E> _debounce<E>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._mealRepository) : super(const SearchInitial()) {
    on<SearchQueryChangedEvent>(
      _onQueryChanged,
      transformer: _debounce(const Duration(milliseconds: 400)),
    );
    on<SearchByFirstLetterEvent>(_onByFirstLetter);
    on<SearchClearEvent>(_onClear);
  }

  final MealRepository _mealRepository;

  Future<void> _onQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    final result = await _mealRepository.searchMealsByName(query);
    if (result.isSuccess) {
      final meals = result.data ?? [];
      if (meals.isEmpty) {
        emit(SearchEmpty(query));
      } else {
        emit(SearchSuccess(meals: meals, query: query));
      }
    } else {
      emit(SearchFailure(result.failure!.message));
    }
  }

  Future<void> _onByFirstLetter(
    SearchByFirstLetterEvent event,
    Emitter<SearchState> emit,
  ) async {
    final letter = event.letter.trim();
    if (letter.isEmpty) return;

    emit(const SearchLoading());

    final result = await _mealRepository.searchMealsByFirstLetter(letter);
    if (result.isSuccess) {
      final meals = result.data ?? [];
      if (meals.isEmpty) {
        emit(SearchEmpty(letter));
      } else {
        emit(SearchSuccess(meals: meals, query: letter));
      }
    } else {
      emit(SearchFailure(result.failure!.message));
    }
  }

  void _onClear(
    SearchClearEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(const SearchInitial());
  }
}
