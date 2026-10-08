import 'package:equatable/equatable.dart';
import '../../../data/models/ingredient/ingredient_model.dart';

abstract class IngredientsState extends Equatable {
  const IngredientsState();

  @override
  List<Object?> get props => [];
}

class IngredientsInitial extends IngredientsState {
  const IngredientsInitial();
}

class IngredientsLoading extends IngredientsState {
  const IngredientsLoading();
}

class IngredientsSuccess extends IngredientsState {
  const IngredientsSuccess({
    required this.allIngredients,
    required this.filteredIngredients,
    this.searchQuery = '',
  });

  final List<IngredientModel> allIngredients;
  final List<IngredientModel> filteredIngredients;
  final String searchQuery;

  @override
  List<Object?> get props => [allIngredients, filteredIngredients, searchQuery];
}

class IngredientsFailure extends IngredientsState {
  const IngredientsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
