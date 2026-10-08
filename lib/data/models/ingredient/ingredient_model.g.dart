// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientResponse _$IngredientResponseFromJson(Map<String, dynamic> json) =>
    IngredientResponse(
      meals: (json['meals'] as List<dynamic>?)
          ?.map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IngredientResponseToJson(IngredientResponse instance) =>
    <String, dynamic>{'meals': instance.meals};

IngredientModel _$IngredientModelFromJson(Map<String, dynamic> json) =>
    IngredientModel(
      idIngredient: json['idIngredient'] as String,
      strIngredient: json['strIngredient'] as String,
      strDescription: json['strDescription'] as String?,
      strType: json['strType'] as String?,
    );

Map<String, dynamic> _$IngredientModelToJson(IngredientModel instance) =>
    <String, dynamic>{
      'idIngredient': instance.idIngredient,
      'strIngredient': instance.strIngredient,
      'strDescription': instance.strDescription,
      'strType': instance.strType,
    };
