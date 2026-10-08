import 'package:json_annotation/json_annotation.dart';

part 'ingredient_model.g.dart';

@JsonSerializable()
class IngredientResponse {
  const IngredientResponse({this.meals});

  final List<IngredientModel>? meals;

  factory IngredientResponse.fromJson(Map<String, dynamic> json) =>
      _$IngredientResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientResponseToJson(this);
}

@JsonSerializable()
class IngredientModel {
  const IngredientModel({
    required this.idIngredient,
    required this.strIngredient,
    this.strDescription,
    this.strType,
  });

  final String idIngredient;
  final String strIngredient;
  final String? strDescription;
  final String? strType;

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientModelFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientModelToJson(this);
}
