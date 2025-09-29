// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelV2Adapter extends TypeAdapter<UserModelV2> {
  @override
  final int typeId = 126;

  @override
  UserModelV2 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModelV2(
      id: fields[0] as int,
      username: fields[1] as String,
      displayName: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModelV2 obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.displayName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelV2Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserModelV3Adapter extends TypeAdapter<UserModelV3> {
  @override
  final int typeId = 121;

  @override
  UserModelV3 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModelV3(
      id: fields[0] as int,
      username: fields[1] as String,
      email: fields[2] as String?,
      firstName: fields[3] as String?,
      lastName: fields[4] as String?,
      dateJoined: fields[5] as DateTime?,
      isStaff: fields[6] as bool,
      isActive: fields[7] as bool,
      isSuperuser: fields[8] as bool,
      groups: (fields[9] as List).cast<int>(),
      userPermissions: (fields[10] as List).cast<String>(),
      inheritedPermissions: (fields[11] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModelV3 obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.dateJoined)
      ..writeByte(6)
      ..write(obj.isStaff)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.isSuperuser)
      ..writeByte(9)
      ..write(obj.groups)
      ..writeByte(10)
      ..write(obj.userPermissions)
      ..writeByte(11)
      ..write(obj.inheritedPermissions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelV3Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModelV2 _$UserModelV2FromJson(Map<String, dynamic> json) => UserModelV2(
      id: json['user_id'] as int,
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
    );

Map<String, dynamic> _$UserModelV2ToJson(UserModelV2 instance) =>
    <String, dynamic>{
      'user_id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
    };

UserModelV3 _$UserModelV3FromJson(Map<String, dynamic> json) => UserModelV3(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      dateJoined: json['date_joined'] == null
          ? null
          : DateTime.parse(json['date_joined'] as String),
      isStaff: json['is_staff'] as bool,
      isActive: json['is_active'] as bool,
      isSuperuser: json['is_superuser'] as bool,
      groups: (json['groups'] as List<dynamic>).map((e) => e as int).toList(),
      userPermissions: (json['user_permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      inheritedPermissions: (json['inherited_permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserModelV3ToJson(UserModelV3 instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'date_joined': instance.dateJoined?.toIso8601String(),
      'is_staff': instance.isStaff,
      'is_active': instance.isActive,
      'is_superuser': instance.isSuperuser,
      'groups': instance.groups,
      'user_permissions': instance.userPermissions,
      'inherited_permissions': instance.inheritedPermissions,
    };
