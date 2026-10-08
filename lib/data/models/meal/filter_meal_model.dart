import 'package:json_annotation/json_annotation.dart';

part 'filter_meal_model.g.dart';

@JsonSerializable()
class FilterMealResponse {
  const FilterMealResponse({this.meals});

  final List<FilterMealModel>? meals;

  factory FilterMealResponse.fromJson(Map<String, dynamic> json) =>
      _$FilterMealResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FilterMealResponseToJson(this);
}

@JsonSerializable()
class FilterMealModel {
  const FilterMealModel({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    this.strArea,
    this.strCountry,
  });

  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String? strArea;
  final String? strCountry;

  factory FilterMealModel.fromJson(Map<String, dynamic> json) =>
      _$FilterMealModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterMealModelToJson(this);
}
