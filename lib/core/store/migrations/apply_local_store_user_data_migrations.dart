import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_mobile/constants.dart';

Future<void> applyLocalStoreUserDataMigrations() async {
  final buildNumber = int.tryParse(packageInfo.buildNumber);

  if (buildNumber == null || buildNumber < 6600) return;

  final storage = HydratedBloc.storage;
  final localStoreState = storage.read('LocalStore') as Map<String, dynamic>?;
  if (localStoreState == null) return;
  if (!localStoreState.containsKey('localUserData')) {
    return;
  }
  final localUserData =
      localStoreState['localUserData'] as Map<String, dynamic>;
  for (var userEntry in localUserData.entries) {
    final localUserId = userEntry.key;
    final userData = userEntry.value as Map<String, dynamic>;
  }
}
