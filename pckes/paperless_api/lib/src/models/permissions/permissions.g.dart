// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PermissionsAdapter extends TypeAdapter<Permissions> {
  @override
  final int typeId = 125;

  @override
  Permissions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Permissions(
      view: fields[0] as UsersAndGroupsPermissions,
      change: fields[1] as UsersAndGroupsPermissions,
    );
  }

  @override
  void write(BinaryWriter writer, Permissions obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.view)
      ..writeByte(1)
      ..write(obj.change);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PermissionsImpl _$$PermissionsImplFromJson(Map<String, dynamic> json) =>
    _$PermissionsImpl(
      view: UsersAndGroupsPermissions.fromJson(
          json['view'] as Map<String, dynamic>),
      change: UsersAndGroupsPermissions.fromJson(
          json['change'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PermissionsImplToJson(_$PermissionsImpl instance) =>
    <String, dynamic>{
      'view': instance.view,
      'change': instance.change,
    };
