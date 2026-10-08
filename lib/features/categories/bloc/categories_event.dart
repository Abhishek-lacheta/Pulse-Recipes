import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class CategoriesFetchEvent extends CategoriesEvent {
  const CategoriesFetchEvent();
}
