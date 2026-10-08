import 'package:json_annotation/json_annotation.dart';

part 'area_model.g.dart';

@JsonSerializable()
class AreaResponse {
  const AreaResponse({this.meals});

  final List<AreaModel>? meals;

  factory AreaResponse.fromJson(Map<String, dynamic> json) =>
      _$AreaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AreaResponseToJson(this);
}

@JsonSerializable()
class AreaModel {
  const AreaModel({
    required this.strArea,
    this.strCountry,
  });

  final String strArea;
  final String? strCountry;

  factory AreaModel.fromJson(Map<String, dynamic> json) =>
      _$AreaModelFromJson(json);

  Map<String, dynamic> toJson() => _$AreaModelToJson(this);
}
