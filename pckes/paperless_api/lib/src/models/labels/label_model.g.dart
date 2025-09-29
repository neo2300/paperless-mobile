// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Correspondent _$CorrespondentFromJson(Map<String, dynamic> json) =>
    Correspondent(
      lastCorrespondence: _$JsonConverterFromJson<String, DateTime>(
          json['last_correspondence'],
          const LocalDateTimeJsonConverter().fromJson),
      name: json['name'] as String,
      id: json['id'] as int?,
      slug: json['slug'] as String?,
      match: json['match'] as String? ?? "",
      matchingAlgorithm: $enumDecodeNullable(
              _$MatchingAlgorithmEnumMap, json['matching_algorithm']) ??
          MatchingAlgorithm.defaultValue,
      isInsensitive: json['is_insensitive'] as bool? ?? true,
      documentCount: json['document_count'] as int?,
      owner: json['owner'] as int?,
      userCanChange: json['user_can_change'] as bool?,
    );

Map<String, dynamic> _$CorrespondentToJson(Correspondent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  writeNotNull('slug', instance.slug);
  val['match'] = instance.match;
  val['matching_algorithm'] =
      _$MatchingAlgorithmEnumMap[instance.matchingAlgorithm]!;
  writeNotNull('is_insensitive', instance.isInsensitive);
  writeNotNull('document_count', instance.documentCount);
  writeNotNull('owner', instance.owner);
  writeNotNull('user_can_change', instance.userCanChange);
  writeNotNull(
      'last_correspondence',
      _$JsonConverterToJson<String, DateTime>(instance.lastCorrespondence,
          const LocalDateTimeJsonConverter().toJson));
  return val;
}

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$MatchingAlgorithmEnumMap = {
  MatchingAlgorithm.none: 0,
  MatchingAlgorithm.anyWord: 1,
  MatchingAlgorithm.allWords: 2,
  MatchingAlgorithm.exactMatch: 3,
  MatchingAlgorithm.regex: 4,
  MatchingAlgorithm.fuzzy: 5,
  MatchingAlgorithm.auto: 6,
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

DocumentType _$DocumentTypeFromJson(Map<String, dynamic> json) => DocumentType(
      id: json['id'] as int?,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      match: json['match'] as String? ?? "",
      matchingAlgorithm: $enumDecodeNullable(
              _$MatchingAlgorithmEnumMap, json['matching_algorithm']) ??
          MatchingAlgorithm.defaultValue,
      isInsensitive: json['is_insensitive'] as bool? ?? true,
      documentCount: json['document_count'] as int?,
      owner: json['owner'] as int?,
      userCanChange: json['user_can_change'] as bool?,
    );

Map<String, dynamic> _$DocumentTypeToJson(DocumentType instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  writeNotNull('slug', instance.slug);
  val['match'] = instance.match;
  val['matching_algorithm'] =
      _$MatchingAlgorithmEnumMap[instance.matchingAlgorithm]!;
  writeNotNull('is_insensitive', instance.isInsensitive);
  writeNotNull('document_count', instance.documentCount);
  writeNotNull('owner', instance.owner);
  writeNotNull('user_can_change', instance.userCanChange);
  return val;
}

StoragePath _$StoragePathFromJson(Map<String, dynamic> json) => StoragePath(
      id: json['id'] as int?,
      name: json['name'] as String,
      path: json['path'] as String? ?? '',
      slug: json['slug'] as String?,
      match: json['match'] as String? ?? "",
      matchingAlgorithm: $enumDecodeNullable(
              _$MatchingAlgorithmEnumMap, json['matching_algorithm']) ??
          MatchingAlgorithm.defaultValue,
      isInsensitive: json['is_insensitive'] as bool? ?? true,
      documentCount: json['document_count'] as int?,
      owner: json['owner'] as int?,
      userCanChange: json['user_can_change'] as bool?,
    );

Map<String, dynamic> _$StoragePathToJson(StoragePath instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  writeNotNull('slug', instance.slug);
  val['match'] = instance.match;
  val['matching_algorithm'] =
      _$MatchingAlgorithmEnumMap[instance.matchingAlgorithm]!;
  writeNotNull('is_insensitive', instance.isInsensitive);
  writeNotNull('document_count', instance.documentCount);
  writeNotNull('owner', instance.owner);
  writeNotNull('user_can_change', instance.userCanChange);
  val['path'] = instance.path;
  return val;
}

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      id: json['id'] as int?,
      name: json['name'] as String,
      documentCount: json['document_count'] as int?,
      isInsensitive: json['is_insensitive'] as bool? ?? true,
      match: json['match'] as String? ?? "",
      matchingAlgorithm: $enumDecodeNullable(
              _$MatchingAlgorithmEnumMap, json['matching_algorithm']) ??
          MatchingAlgorithm.defaultValue,
      slug: json['slug'] as String?,
      color: const HexColorJsonConverter().fromJson(json['color']),
      textColor: const HexColorJsonConverter().fromJson(json['text_color']),
      isInboxTag: json['is_inbox_tag'] as bool? ?? false,
      owner: json['owner'] as int?,
      userCanChange: json['user_can_change'] as bool?,
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'match': instance.match,
      'matching_algorithm':
          _$MatchingAlgorithmEnumMap[instance.matchingAlgorithm]!,
      'is_insensitive': instance.isInsensitive,
      'document_count': instance.documentCount,
      'owner': instance.owner,
      'user_can_change': instance.userCanChange,
      'text_color': const HexColorJsonConverter().toJson(instance.textColor),
      'color': const HexColorJsonConverter().toJson(instance.color),
      'is_inbox_tag': instance.isInboxTag,
    };
