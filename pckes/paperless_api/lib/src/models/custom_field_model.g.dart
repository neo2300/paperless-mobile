// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_field_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomFieldModel _$CustomFieldModelFromJson(Map<String, dynamic> json) =>
    CustomFieldModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      dataType: $enumDecode(_$CustomFieldDataTypeEnumMap, json['dataType']),
    );

Map<String, dynamic> _$CustomFieldModelToJson(CustomFieldModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dataType': _$CustomFieldDataTypeEnumMap[instance.dataType]!,
    };

const _$CustomFieldDataTypeEnumMap = {
  CustomFieldDataType.text: 'text',
  CustomFieldDataType.boolean: 'boolean',
  CustomFieldDataType.date: 'date',
  CustomFieldDataType.url: 'url',
  CustomFieldDataType.integer: 'integer',
  CustomFieldDataType.number: 'number',
  CustomFieldDataType.monetary: 'monetary',
};

CustomFieldInstance _$CustomFieldInstanceFromJson(Map<String, dynamic> json) =>
    CustomFieldInstance(
      id: json['id'] as int?,
      value: json['value'],
    );

Map<String, dynamic> _$CustomFieldInstanceToJson(
        CustomFieldInstance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
    };
