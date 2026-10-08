import 'package:equatable/equatable.dart';

/// Clean model representing an ingredient and its associated measure.
class MealIngredient extends Equatable {
  const MealIngredient({
    required this.name,
    required this.measure,
  });

  final String name;
  final String measure;

  @override
  List<Object?> get props => [name, measure];
}
