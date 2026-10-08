// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_meal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterMealResponse _$FilterMealResponseFromJson(Map<String, dynamic> json) =>
    FilterMealResponse(
      meals: (json['meals'] as List<dynamic>?)
          ?.map((e) => FilterMealModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FilterMealResponseToJson(FilterMealResponse instance) =>
    <String, dynamic>{'meals': instance.meals};

FilterMealModel _$FilterMealModelFromJson(Map<String, dynamic> json) =>
    FilterMealModel(
      idMeal: json['idMeal'] as String,
      strMeal: json['strMeal'] as String,
      strMealThumb: json['strMealThumb'] as String,
      strArea: json['strArea'] as String?,
      strCountry: json['strCountry'] as String?,
    );

Map<String, dynamic> _$FilterMealModelToJson(FilterMealModel instance) =>
    <String, dynamic>{
      'idMeal': instance.idMeal,
      'strMeal': instance.strMeal,
      'strMealThumb': instance.strMealThumb,
      'strArea': instance.strArea,
      'strCountry': instance.strCountry,
    };
