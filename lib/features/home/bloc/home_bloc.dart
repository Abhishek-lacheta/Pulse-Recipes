import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/meal_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

export 'home_event.dart';
export 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._mealRepository) : super(const HomeInitial()) {
    on<HomeFetchDataEvent>(_onFetchData);
  }

  final MealRepository _mealRepository;

  Future<void> _onFetchData(
    HomeFetchDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(const HomeLoading());
    }

    try {
      final randomFuture = _mealRepository.getRandomMeal();
      final categoriesFuture = _mealRepository.getCategories();
      final areasFuture = _mealRepository.getAreas();
      final popularFuture = _mealRepository.filterByCategory('Seafood');

      final randomResult = await randomFuture;
      final categoriesResult = await categoriesFuture;
      final areasResult = await areasFuture;
      final popularResult = await popularFuture;

      if (randomResult.isFailure) {
        emit(HomeFailure(randomResult.failure!.message));
        return;
      }
      if (categoriesResult.isFailure) {
        emit(HomeFailure(categoriesResult.failure!.message));
        return;
      }

      emit(
        HomeSuccess(
          featuredMeal: randomResult.data!,
          categories: categoriesResult.data ?? [],
          areas: areasResult.data ?? [],
          popularMeals: popularResult.data ?? [],
        ),
      );
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }
}
