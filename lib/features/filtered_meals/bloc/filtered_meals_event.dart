import 'package:equatable/equatable.dart';

abstract class FilteredMealsEvent extends Equatable {
  const FilteredMealsEvent();

  @override
  List<Object?> get props => [];
}

class FilteredMealsFetchEvent extends FilteredMealsEvent {
  const FilteredMealsFetchEvent({
    this.category,
    this.area,
    this.ingredient,
  });

  final String? category;
  final String? area;
  final String? ingredient;

  @override
  List<Object?> get props => [category, area, ingredient];
}
