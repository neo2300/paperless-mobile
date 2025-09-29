// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnyAssignedTagsQuery _$AnyAssignedTagsQueryFromJson(
        Map<String, dynamic> json) =>
    AnyAssignedTagsQuery(
      tagIds:
          (json['tagIds'] as List<dynamic>?)?.map((e) => e as int).toSet() ??
              const {},
    );

Map<String, dynamic> _$AnyAssignedTagsQueryToJson(
        AnyAssignedTagsQuery instance) =>
    <String, dynamic>{
      'tagIds': instance.tagIds.toList(),
    };

IdsTagsQuery _$IdsTagsQueryFromJson(Map<String, dynamic> json) => IdsTagsQuery(
      include:
          (json['include'] as List<dynamic>?)?.map((e) => e as int).toSet() ??
              const {},
      exclude:
          (json['exclude'] as List<dynamic>?)?.map((e) => e as int).toSet() ??
              const {},
    );

Map<String, dynamic> _$IdsTagsQueryToJson(IdsTagsQuery instance) =>
    <String, dynamic>{
      'include': instance.include.toList(),
      'exclude': instance.exclude.toList(),
    };
