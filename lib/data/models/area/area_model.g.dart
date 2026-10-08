// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaResponse _$AreaResponseFromJson(Map<String, dynamic> json) => AreaResponse(
  meals: (json['meals'] as List<dynamic>?)
      ?.map((e) => AreaModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AreaResponseToJson(AreaResponse instance) =>
    <String, dynamic>{'meals': instance.meals};

AreaModel _$AreaModelFromJson(Map<String, dynamic> json) => AreaModel(
  strArea: json['strArea'] as String,
  strCountry: json['strCountry'] as String?,
);

Map<String, dynamic> _$AreaModelToJson(AreaModel instance) => <String, dynamic>{
  'strArea': instance.strArea,
  'strCountry': instance.strCountry,
};
