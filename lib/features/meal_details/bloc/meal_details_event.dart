import 'package:equatable/equatable.dart';

abstract class MealDetailsEvent extends Equatable {
  const MealDetailsEvent();

  @override
  List<Object?> get props => [];
}

class MealDetailsFetchEvent extends MealDetailsEvent {
  const MealDetailsFetchEvent(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
