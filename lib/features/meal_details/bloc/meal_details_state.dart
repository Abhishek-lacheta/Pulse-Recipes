import 'package:equatable/equatable.dart';
import '../../../data/models/meal/meal_detail_model.dart';

abstract class MealDetailsState extends Equatable {
  const MealDetailsState();

  @override
  List<Object?> get props => [];
}

class MealDetailsInitial extends MealDetailsState {
  const MealDetailsInitial();
}

class MealDetailsLoading extends MealDetailsState {
  const MealDetailsLoading();
}

class MealDetailsSuccess extends MealDetailsState {
  const MealDetailsSuccess(this.meal);

  final MealDetailModel meal;

  @override
  List<Object?> get props => [meal];
}

class MealDetailsFailure extends MealDetailsState {
  const MealDetailsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
