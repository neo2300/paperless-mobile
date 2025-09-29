// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_filter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentFilterAdapter extends TypeAdapter<DocumentFilter> {
  @override
  final int typeId = 128;

  @override
  DocumentFilter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DocumentFilter(
      documentTypes: fields[2] as IdQueryParameter,
      correspondents: fields[3] as IdQueryParameter,
      storagePaths: fields[4] as IdQueryParameter,
      asnQuery: fields[5] as IdQueryParameter,
      tags: fields[6] as TagsQuery,
      sortField: fields[7] as SortField?,
      sortOrder: fields[8] as SortOrder,
      page: fields[1] as int,
      pageSize: fields[0] as int,
      query: fields[12] as TextQuery,
      added: fields[10] as DateRangeQuery,
      created: fields[9] as DateRangeQuery,
      modified: fields[11] as DateRangeQuery,
      moreLike: fields[13] as int?,
      selectedView: fields[14] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DocumentFilter obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.pageSize)
      ..writeByte(1)
      ..write(obj.page)
      ..writeByte(2)
      ..write(obj.documentTypes)
      ..writeByte(3)
      ..write(obj.correspondents)
      ..writeByte(4)
      ..write(obj.storagePaths)
      ..writeByte(5)
      ..write(obj.asnQuery)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.sortField)
      ..writeByte(8)
      ..write(obj.sortOrder)
      ..writeByte(9)
      ..write(obj.created)
      ..writeByte(10)
      ..write(obj.added)
      ..writeByte(11)
      ..write(obj.modified)
      ..writeByte(12)
      ..write(obj.query)
      ..writeByte(13)
      ..write(obj.moreLike)
      ..writeByte(14)
      ..write(obj.selectedView);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentFilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentFilter _$DocumentFilterFromJson(Map<String, dynamic> json) =>
    DocumentFilter(
      documentTypes: json['documentTypes'] == null
          ? const UnsetIdQueryParameter()
          : IdQueryParameter.fromJson(
              json['documentTypes'] as Map<String, dynamic>),
      correspondents: json['correspondents'] == null
          ? const UnsetIdQueryParameter()
          : IdQueryParameter.fromJson(
              json['correspondents'] as Map<String, dynamic>),
      storagePaths: json['storagePaths'] == null
          ? const UnsetIdQueryParameter()
          : IdQueryParameter.fromJson(
              json['storagePaths'] as Map<String, dynamic>),
      asnQuery: json['asnQuery'] == null
          ? const UnsetIdQueryParameter()
          : IdQueryParameter.fromJson(json['asnQuery'] as Map<String, dynamic>),
      tags: json['tags'] == null
          ? const IdsTagsQuery()
          : TagsQuery.fromJson(json['tags'] as Map<String, dynamic>),
      sortField: $enumDecodeNullable(_$SortFieldEnumMap, json['sortField']) ??
          SortField.created,
      sortOrder: $enumDecodeNullable(_$SortOrderEnumMap, json['sortOrder']) ??
          SortOrder.descending,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 25,
      query: json['query'] == null
          ? const TextQuery()
          : TextQuery.fromJson(json['query'] as Map<String, dynamic>),
      added: json['added'] == null
          ? const UnsetDateRangeQuery()
          : DateRangeQuery.fromJson(json['added'] as Map<String, dynamic>),
      created: json['created'] == null
          ? const UnsetDateRangeQuery()
          : DateRangeQuery.fromJson(json['created'] as Map<String, dynamic>),
      modified: json['modified'] == null
          ? const UnsetDateRangeQuery()
          : DateRangeQuery.fromJson(json['modified'] as Map<String, dynamic>),
      moreLike: json['moreLike'] as int?,
      selectedView: json['selectedView'] as int?,
    );

Map<String, dynamic> _$DocumentFilterToJson(DocumentFilter instance) =>
    <String, dynamic>{
      'pageSize': instance.pageSize,
      'page': instance.page,
      'documentTypes': instance.documentTypes,
      'correspondents': instance.correspondents,
      'storagePaths': instance.storagePaths,
      'asnQuery': instance.asnQuery,
      'tags': instance.tags,
      'sortField': _$SortFieldEnumMap[instance.sortField],
      'sortOrder': _$SortOrderEnumMap[instance.sortOrder]!,
      'created': instance.created,
      'added': instance.added,
      'modified': instance.modified,
      'query': instance.query,
      'moreLike': instance.moreLike,
      'selectedView': instance.selectedView,
    };

const _$SortFieldEnumMap = {
  SortField.archiveSerialNumber: 'archive_serial_number',
  SortField.correspondentName: 'correspondent__name',
  SortField.title: 'title',
  SortField.documentType: 'document_type__name',
  SortField.created: 'created',
  SortField.added: 'added',
  SortField.modified: 'modified',
  SortField.score: 'score',
};

const _$SortOrderEnumMap = {
  SortOrder.ascending: 'ascending',
  SortOrder.descending: 'descending',
};
