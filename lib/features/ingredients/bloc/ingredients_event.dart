import 'package:equatable/equatable.dart';

abstract class IngredientsEvent extends Equatable {
  const IngredientsEvent();

  @override
  List<Object?> get props => [];
}

class IngredientsFetchEvent extends IngredientsEvent {
  const IngredientsFetchEvent();
}

class IngredientsFilterQueryEvent extends IngredientsEvent {
  const IngredientsFilterQueryEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
