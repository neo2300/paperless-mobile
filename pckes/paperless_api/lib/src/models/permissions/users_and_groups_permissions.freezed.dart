// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_and_groups_permissions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UsersAndGroupsPermissions _$UsersAndGroupsPermissionsFromJson(
    Map<String, dynamic> json) {
  return _UsersAndGroupsPermissions.fromJson(json);
}

/// @nodoc
mixin _$UsersAndGroupsPermissions {
  @HiveField(0)
  List<int> get users => throw _privateConstructorUsedError;
  @HiveField(1)
  List<int> get groups => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UsersAndGroupsPermissionsCopyWith<UsersAndGroupsPermissions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersAndGroupsPermissionsCopyWith<$Res> {
  factory $UsersAndGroupsPermissionsCopyWith(UsersAndGroupsPermissions value,
          $Res Function(UsersAndGroupsPermissions) then) =
      _$UsersAndGroupsPermissionsCopyWithImpl<$Res, UsersAndGroupsPermissions>;
  @useResult
  $Res call({@HiveField(0) List<int> users, @HiveField(1) List<int> groups});
}

/// @nodoc
class _$UsersAndGroupsPermissionsCopyWithImpl<$Res,
        $Val extends UsersAndGroupsPermissions>
    implements $UsersAndGroupsPermissionsCopyWith<$Res> {
  _$UsersAndGroupsPermissionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? groups = null,
  }) {
    return _then(_value.copyWith(
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<int>,
      groups: null == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UsersAndGroupsPermissionsImplCopyWith<$Res>
    implements $UsersAndGroupsPermissionsCopyWith<$Res> {
  factory _$$UsersAndGroupsPermissionsImplCopyWith(
          _$UsersAndGroupsPermissionsImpl value,
          $Res Function(_$UsersAndGroupsPermissionsImpl) then) =
      __$$UsersAndGroupsPermissionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) List<int> users, @HiveField(1) List<int> groups});
}

/// @nodoc
class __$$UsersAndGroupsPermissionsImplCopyWithImpl<$Res>
    extends _$UsersAndGroupsPermissionsCopyWithImpl<$Res,
        _$UsersAndGroupsPermissionsImpl>
    implements _$$UsersAndGroupsPermissionsImplCopyWith<$Res> {
  __$$UsersAndGroupsPermissionsImplCopyWithImpl(
      _$UsersAndGroupsPermissionsImpl _value,
      $Res Function(_$UsersAndGroupsPermissionsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? groups = null,
  }) {
    return _then(_$UsersAndGroupsPermissionsImpl(
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<int>,
      groups: null == groups
          ? _value._groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UsersAndGroupsPermissionsImpl implements _UsersAndGroupsPermissions {
  const _$UsersAndGroupsPermissionsImpl(
      {@HiveField(0) final List<int> users = const [],
      @HiveField(1) final List<int> groups = const []})
      : _users = users,
        _groups = groups;

  factory _$UsersAndGroupsPermissionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsersAndGroupsPermissionsImplFromJson(json);

  final List<int> _users;
  @override
  @JsonKey()
  @HiveField(0)
  List<int> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  final List<int> _groups;
  @override
  @JsonKey()
  @HiveField(1)
  List<int> get groups {
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groups);
  }

  @override
  String toString() {
    return 'UsersAndGroupsPermissions(users: $users, groups: $groups)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersAndGroupsPermissionsImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality().equals(other._groups, _groups));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_users),
      const DeepCollectionEquality().hash(_groups));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersAndGroupsPermissionsImplCopyWith<_$UsersAndGroupsPermissionsImpl>
      get copyWith => __$$UsersAndGroupsPermissionsImplCopyWithImpl<
          _$UsersAndGroupsPermissionsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsersAndGroupsPermissionsImplToJson(
      this,
    );
  }
}

abstract class _UsersAndGroupsPermissions implements UsersAndGroupsPermissions {
  const factory _UsersAndGroupsPermissions(
      {@HiveField(0) final List<int> users,
      @HiveField(1) final List<int> groups}) = _$UsersAndGroupsPermissionsImpl;

  factory _UsersAndGroupsPermissions.fromJson(Map<String, dynamic> json) =
      _$UsersAndGroupsPermissionsImpl.fromJson;

  @override
  @HiveField(0)
  List<int> get users;
  @override
  @HiveField(1)
  List<int> get groups;
  @override
  @JsonKey(ignore: true)
  _$$UsersAndGroupsPermissionsImplCopyWith<_$UsersAndGroupsPermissionsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
