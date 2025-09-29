// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteModelImpl _$$NoteModelImplFromJson(Map<String, dynamic> json) =>
    _$NoteModelImpl(
      id: json['id'] as int?,
      note: json['note'] as String?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      document: json['document'] as int?,
      user: parseNoteUserFromJson(json['user']),
    );

Map<String, dynamic> _$$NoteModelImplToJson(_$NoteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'created': instance.created?.toIso8601String(),
      'document': instance.document,
      'user': instance.user,
    };
