part of 'local_store.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.none)
class LocalStoreState {
  const LocalStoreState({
    this.loggedInAppUserId,
    this.readHints = const [],
    required this.globalSettings,
    this.localUserData = const {},
  });

  final String? loggedInAppUserId;
  final List<String> readHints;
  final GlobalSettings globalSettings;
  final Map<String, LocalUserData> localUserData;

  Map<String, dynamic> toJson() => _$LocalStoreStateToJson(this);
  factory LocalStoreState.fromJson(Map<String, dynamic> json) =>
      _$LocalStoreStateFromJson(json);
}
