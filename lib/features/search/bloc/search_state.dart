import 'package:equatable/equatable.dart';
import '../../../data/models/meal/meal_detail_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchSuccess extends SearchState {
  const SearchSuccess({
    required this.meals,
    required this.query,
  });

  final List<MealDetailModel> meals;
  final String query;

  @override
  List<Object?> get props => [meals, query];
}

class SearchEmpty extends SearchState {
  const SearchEmpty(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class SearchFailure extends SearchState {
  const SearchFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
