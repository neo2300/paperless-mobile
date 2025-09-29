// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_query_parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnsetIdQueryParameter _$UnsetIdQueryParameterFromJson(
        Map<String, dynamic> json) =>
    UnsetIdQueryParameter();

Map<String, dynamic> _$UnsetIdQueryParameterToJson(
        UnsetIdQueryParameter instance) =>
    <String, dynamic>{};

NotAssignedIdQueryParameter _$NotAssignedIdQueryParameterFromJson(
        Map<String, dynamic> json) =>
    NotAssignedIdQueryParameter();

Map<String, dynamic> _$NotAssignedIdQueryParameterToJson(
        NotAssignedIdQueryParameter instance) =>
    <String, dynamic>{};

SetIdQueryParameter _$SetIdQueryParameterFromJson(Map<String, dynamic> json) =>
    SetIdQueryParameter(
      ids: (json['ids'] as List<dynamic>).map((e) => e as int).toSet(),
      type:
          $enumDecodeNullable(_$SetIdQueryParameterTypeEnumMap, json['type']) ??
              SetIdQueryParameterType.include,
    );

Map<String, dynamic> _$SetIdQueryParameterToJson(
        SetIdQueryParameter instance) =>
    <String, dynamic>{
      'ids': instance.ids.toList(),
      'type': _$SetIdQueryParameterTypeEnumMap[instance.type]!,
    };

const _$SetIdQueryParameterTypeEnumMap = {
  SetIdQueryParameterType.include: 'include',
  SetIdQueryParameterType.exclude: 'exclude',
};
