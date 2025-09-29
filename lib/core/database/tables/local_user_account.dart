import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/database/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/local_user_settings.dart';

part 'local_user_account.g.dart';

@HiveType(typeId: HiveTypeIds.localUserAccount)
class LocalUserAccount extends HiveObject {
  @HiveField(0)
  final String serverUrl;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final LocalUserSettings settings;

  @HiveField(8, defaultValue: 2)
  int apiVersion;

  LocalUserAccount({
    required this.id,
    required this.serverUrl,
    required this.settings,
    required this.apiVersion,
  });
}
