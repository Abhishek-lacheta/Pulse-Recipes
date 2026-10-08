import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/meal_repository.dart';
import 'meal_details_event.dart';
import 'meal_details_state.dart';

export 'meal_details_event.dart';
export 'meal_details_state.dart';

class MealDetailsBloc extends Bloc<MealDetailsEvent, MealDetailsState> {
  MealDetailsBloc(this._mealRepository) : super(const MealDetailsInitial()) {
    on<MealDetailsFetchEvent>(_onFetch);
  }

  final MealRepository _mealRepository;

  Future<void> _onFetch(
    MealDetailsFetchEvent event,
    Emitter<MealDetailsState> emit,
  ) async {
    emit(const MealDetailsLoading());
    final result = await _mealRepository.getMealDetails(event.id);
    if (result.isSuccess) {
      emit(MealDetailsSuccess(result.data!));
    } else {
      emit(MealDetailsFailure(result.failure!.message));
    }
  }
}
