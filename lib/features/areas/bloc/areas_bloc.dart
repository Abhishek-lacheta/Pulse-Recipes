import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/meal_repository.dart';
import 'areas_event.dart';
import 'areas_state.dart';

export 'areas_event.dart';
export 'areas_state.dart';

class AreasBloc extends Bloc<AreasEvent, AreasState> {
  AreasBloc(this._mealRepository) : super(const AreasInitial()) {
    on<AreasFetchEvent>(_onFetch);
  }

  final MealRepository _mealRepository;

  Future<void> _onFetch(
    AreasFetchEvent event,
    Emitter<AreasState> emit,
  ) async {
    emit(const AreasLoading());
    final result = await _mealRepository.getAreas();
    if (result.isSuccess) {
      emit(AreasSuccess(result.data ?? []));
    } else {
      emit(AreasFailure(result.failure!.message));
    }
  }
}
