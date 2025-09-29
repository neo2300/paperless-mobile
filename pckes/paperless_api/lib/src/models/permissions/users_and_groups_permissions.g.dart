// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_and_groups_permissions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsersAndGroupsPermissionsAdapter
    extends TypeAdapter<UsersAndGroupsPermissions> {
  @override
  final int typeId = 127;

  @override
  UsersAndGroupsPermissions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsersAndGroupsPermissions(
      users: (fields[0] as List).cast<int>(),
      groups: (fields[1] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, UsersAndGroupsPermissions obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.users)
      ..writeByte(1)
      ..write(obj.groups);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersAndGroupsPermissionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsersAndGroupsPermissionsImpl _$$UsersAndGroupsPermissionsImplFromJson(
        Map<String, dynamic> json) =>
    _$UsersAndGroupsPermissionsImpl(
      users: (json['users'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          const [],
      groups:
          (json['groups'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              const [],
    );

Map<String, dynamic> _$$UsersAndGroupsPermissionsImplToJson(
        _$UsersAndGroupsPermissionsImpl instance) =>
    <String, dynamic>{
      'users': instance.users,
      'groups': instance.groups,
    };
