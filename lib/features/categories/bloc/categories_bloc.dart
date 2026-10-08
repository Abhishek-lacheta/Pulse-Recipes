import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/meal_repository.dart';
import 'categories_event.dart';
import 'categories_state.dart';

export 'categories_event.dart';
export 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(this._mealRepository) : super(const CategoriesInitial()) {
    on<CategoriesFetchEvent>(_onFetch);
  }

  final MealRepository _mealRepository;

  Future<void> _onFetch(
    CategoriesFetchEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CategoriesLoading());
    final result = await _mealRepository.getCategories();
    if (result.isSuccess) {
      emit(CategoriesSuccess(result.data ?? []));
    } else {
      emit(CategoriesFailure(result.failure!.message));
    }
  }
}
