import 'package:equatable/equatable.dart';
import '../../../data/models/category/category_model.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesSuccess extends CategoriesState {
  const CategoriesSuccess(this.categories);

  final List<CategoryModel> categories;

  @override
  List<Object?> get props => [categories];
}

class CategoriesFailure extends CategoriesState {
  const CategoriesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
