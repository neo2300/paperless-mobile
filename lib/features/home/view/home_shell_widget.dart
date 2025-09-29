import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/database/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/hive/hive_extensions.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/core/service/dio_file_service.dart';
import 'package:paperless_mobile/features/document_scan/cubit/document_scanner_cubit.dart';
import 'package:paperless_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:paperless_mobile/features/inbox/cubit/inbox_cubit.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/features/tasks/model/pending_tasks_notifier.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';
import 'package:provider/provider.dart';

class HomeShellWidget extends StatelessWidget {
  /// The id of the currently authenticated user (e.g. demo@paperless.example.com)
  final String localUserId;

  // A factory providing the API implementations given an API version
  final PaperlessNgxApiV9 paperlessApi;

  final Widget child;

  const HomeShellWidget({
    super.key,
    required this.paperlessApi,
    required this.localUserId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        final currentUserId = settings.loggedInUserId;
        return ValueListenableBuilder(
          valueListenable:
              Hive.localUserAccountBox.listenable(keys: [currentUserId]),
          builder: (context, box, _) {
            if (currentUserId == null) {
              //This only happens during logout...
              //FIXME: Find way so this does not occur anymore
              return const SizedBox.shrink();
            }
            final currentLocalUser = box.get(currentUserId)!;
            return MultiProvider(
              key: ValueKey(currentUserId),
              providers: [
                Provider.value(value: currentLocalUser),
                Provider(
                  create: (context) => CacheManager(
                    Config(
                      // Isolated cache per user.
                      localUserId,
                      fileService:
                          DioFileService(context.read<SessionManager>().client),
                    ),
                  ),
                ),
                Provider.value(value: paperlessApi),
              ],
              builder: (context, _) {
                return MultiProvider(
                  providers: [
                    Provider(
                      lazy: false,
                      create: (context) => DocumentsCubit(
                        context.read(),
                        context.read(),
                        Hive.box<LocalUserAppState>(HiveBoxes.localUserAppState)
                            .get(currentUserId)!,
                        context.read(),
                      )..initialize(),
                    ),
                    Provider(
                      create: (context) =>
                          DocumentScannerCubit(context.read())..initialize(),
                    ),
                    Provider(
                      create: (context) {
                        final inboxCubit = InboxCubit(
                          context.read(),
                          context.read(),
                          context.read(),
                          context.read(),
                          context.read(),
                        );
                        inboxCubit.initialize();
                        return inboxCubit;
                      },
                    ),
                    Provider(
                      create: (context) => SavedViewCubit(
                        context.read(),
                      ),
                    ),
                    Provider(
                      create: (context) => LabelCubit(
                        context.read(),
                      ),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => PendingTasksNotifier(
                        context.read(),
                      ),
                    ),
                  ],
                  child: child,
                );
              },
            );
          },
        );
      },
    );
  }
}
