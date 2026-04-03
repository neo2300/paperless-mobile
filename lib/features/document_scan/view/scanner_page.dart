import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/bloc/loading_status.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/global/constants.dart';
import 'package:paperless_mobile/core/model/info_message_exception.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:paperless_mobile/features/document_scan/cubit/document_scanner_cubit.dart';
import 'package:paperless_mobile/features/document_scan/view/widgets/export_scans_dialog.dart';
import 'package:paperless_mobile/features/document_scan/view/widgets/scanned_image_item.dart';
import 'package:paperless_mobile/features/document_search/view/sliver_search_bar.dart';
import 'package:paperless_mobile/features/document_upload/view/document_upload_preparation_page.dart';
import 'package:paperless_mobile/features/documents/view/pages/document_view.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/connectivity_aware_action_wrapper.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/helpers/permission_helpers.dart';
import 'package:paperless_mobile/routing/routes/scanner_route.dart';
import 'package:paperless_mobile_document_scanner/paperless_mobile_document_scanner.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  final SliverOverlapAbsorberHandle searchBarHandle =
      SliverOverlapAbsorberHandle();
  final SliverOverlapAbsorberHandle actionsHandle =
      SliverOverlapAbsorberHandle();

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        drawer: const AppDrawer(),
        floatingActionButton: FloatingActionButton(
          heroTag: "fab_document_edit",
          onPressed: () => _openDocumentScanner(context),
          child: const Icon(Icons.add_a_photo_outlined),
        ),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: searchBarHandle,
              sliver: SliverSearchBar(titleText: S.of(context)!.scanner),
            ),
            SliverOverlapAbsorber(
              handle: actionsHandle,
              sliver: SliverPinnedHeader(child: _buildActions()),
            ),
          ],
          body: BlocBuilder<DocumentScannerCubit, DocumentScannerState>(
            builder: (context, state) {
              return switch (state.status) {
                LoadingStatus.initial => _buildEmptyState(),
                LoadingStatus.loading => Center(child: Text("Restoring...")),
                LoadingStatus.loaded => _buildImageGrid(state.scans),
                LoadingStatus.error => Placeholder(),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: BlocBuilder<DocumentScannerCubit, DocumentScannerState>(
        builder: (context, state) {
          return RawScrollbar(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            interactive: false,
            thumbVisibility: true,
            thickness: 2,
            radius: Radius.circular(2),
            controller: _scrollController,
            child: SizedBox(
              height: kToolbarHeight + 16,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 16),
                    ActionChip(
                      label: Text(S.of(context)!.previewScan),
                      onPressed: state.scans.isNotEmpty
                          ? () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DocumentView(
                                  bytes: _assembleFileBytes(
                                    state.scans,
                                    forcePdf: true,
                                  ).then((file) => file.bytes),
                                ),
                              ),
                            )
                          : null,
                      avatar: const Icon(Icons.visibility_outlined),
                    ),
                    SizedBox(width: 8),
                    ActionChip(
                      label: Text(S.of(context)!.clearAll),
                      onPressed: state.scans.isEmpty
                          ? null
                          : () => _reset(context),
                      avatar: const Icon(Icons.delete_sweep_outlined),
                    ),
                    SizedBox(width: 8),
                    ConnectivityAwareActionWrapper(
                      offlineBuilder: (context, child) {
                        return ActionChip(
                          label: Text(S.of(context)!.upload),
                          onPressed: null,
                          avatar: const Icon(Icons.upload_outlined),
                        );
                      },
                      disabled: state.scans.isEmpty,
                      child: ActionChip(
                        label: Text(S.of(context)!.upload),
                        onPressed: () =>
                            _onPrepareDocumentUpload(context, state.scans),
                        avatar: const Icon(Icons.upload_outlined),
                      ),
                    ),
                    SizedBox(width: 8),
                    ActionChip(
                      label: Text(S.of(context)!.export),
                      onPressed: state.scans.isEmpty ? null : _onSaveToFile,
                      avatar: const Icon(Icons.save_alt_outlined),
                    ),
                    SizedBox(width: 12),
                  ],
                ).paddedOnly(bottom: 16),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onSaveToFile() async {
    final globalSettings = context.localStore.state.globalSettings;
    final fileName = await showDialog<String>(
      useRootNavigator: false,
      context: context,
      builder: (context) => const ExportScansDialog(),
    );
    if (fileName != null) {
      if (!mounted) return;
      final cubit = context.read<DocumentScannerCubit>();
      final file = await _assembleFileBytes(
        forcePdf: true,
        context.read<DocumentScannerCubit>().state.scans,
      );
      try {
        if (Platform.isAndroid && androidInfo!.version.sdkInt <= 29) {
          final isGranted = await askForPermission(Permission.storage);
          if (!isGranted) {
            if (!mounted) return;
            showSnackBar(
              context,
              "Please grant Paperless Mobile permissions to access your filesystem.",
              action: SnackBarActionConfig(
                label: "OK",
                onPressed: openAppSettings,
              ),
            );
            return;
          }
        }
        await cubit.saveToFile(
          file.bytes,
          "$fileName.pdf",
          globalSettings.preferredLocaleSubtag,
        );
      } catch (error) {
        if (!mounted) return;
        showGenericError(context, error);
      }
    }
  }

  Future<void> _onScanCancelled(
    List<File> files,
    NavigatorState rootNavigator,
  ) async {
    (files) async {
      if (files.isNotEmpty) {
        final shouldDiscard = await showDialog(
          context: context,
          useRootNavigator: true,
          builder: (context) => AlertDialog(
            title: Text("Discard"), //TODO: INTL
            content: Text(
              "Are you sure you want to discard the scanned documents?",
            ),
            actions: [
              DialogConfirmButton(returnValue: true),
              DialogCancelButton(),
            ],
          ),
        );
        if (shouldDiscard) {
          rootNavigator.pop();
          for (var file in files) {
            unawaited(file.delete());
          }
        }
      }
    };
  }

  void _openDocumentScanner(BuildContext context) async {
    final cubit = context.read<DocumentScannerCubit>();
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    final result = await rootNavigator.push<List<File>>(
      MaterialPageRoute(
        builder: (context) => PaperlessMobileDocumentScanner(
          onCancelled: (files) => _onScanCancelled(files, rootNavigator),
          onDone: (files) => rootNavigator.pop(files),
        ),
      ),
    );
    if (result != null) {
      cubit.addScansFromScanner(result);
    }
  }

  void _onPrepareDocumentUpload(BuildContext context, List<File> scans) async {
    final file = await _assembleFileBytes(
      scans,
      forcePdf:
          context.localStore.state.globalSettings.enforceSinglePagePdfUpload,
    );
    if (!context.mounted) return;
    final uploadResult = await DocumentUploadRoute(
      $extra: file.bytes,
      fileExtension: file.extension,
    ).push<DocumentUploadResult>(context);
    if (uploadResult?.success ?? false) {
      if (!context.mounted) return;
      // For paperless version older than 1.11.3, task id will always be null!
      context.read<DocumentScannerCubit>().reset();
      // context
      //     .read<PendingTasksNotifier>()
      //     .listenToTaskChanges(uploadResult!.taskId!);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context)!.noDocumentsScannedYet,
              textAlign: TextAlign.center,
            ),
            TextButton(
              child: Text(S.of(context)!.scanADocument),
              onPressed: () => _openDocumentScanner(context),
            ),
            Text(S.of(context)!.or),
            ConnectivityAwareActionWrapper(
              offlineBuilder: (context, child) => TextButton(
                onPressed: null,
                child: Text(S.of(context)!.uploadADocumentFromThisDevice),
              ),
              child: TextButton(
                onPressed: _onUploadFromFilesystem,
                child: Text(S.of(context)!.uploadADocumentFromThisDevice),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<File> scans) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          SliverOverlapInjector(handle: searchBarHandle),
          SliverOverlapInjector(handle: actionsHandle),
          SliverGrid.builder(
            itemCount: scans.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / sqrt(2),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return ScannedImageItem(
                file: scans[index],
                onDelete: () async {
                  try {
                    context.read<DocumentScannerCubit>().removeScan(
                      scans[index],
                    );
                  } on PaperlessApiException catch (error, stackTrace) {
                    showErrorMessage(context, error, stackTrace);
                  } on InfoMessageException catch (error, stackTrace) {
                    showInfoMessage(context, error, stackTrace);
                  }
                },
                index: index,
                totalNumberOfFiles: scans.length,
              );
            },
          ),
        ],
      ),
    );
  }

  void _reset(BuildContext context) {
    try {
      context.read<DocumentScannerCubit>().reset();
    } on PaperlessApiException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  void _onUploadFromFilesystem() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: supportedFileExtensions
          .map((e) => e.replaceAll(".", ""))
          .toList(),
      withData: true,
      allowMultiple: false,
    );
    if (result?.files.single.path != null) {
      final path = result!.files.single.path!;
      final extension = p.extension(path);
      final filename = p.basenameWithoutExtension(path);
      File file = File(path);
      if (!supportedFileExtensions.contains(extension.toLowerCase())) {
        if (!mounted) return;
        showErrorMessage(
          context,
          const PaperlessApiException(ErrorCode.unsupportedFileFormat),
        );
        return;
      }
      if (!mounted) return;
      DocumentUploadRoute(
        $extra: file.readAsBytesSync(),
        filename: filename,
        title: filename,
        fileExtension: extension,
      ).push<DocumentUploadResult>(context);
      // if (uploadResult.success && uploadResult.taskId != null) {
      //   context
      //       .read<PendingTasksNotifier>()
      //       .listenToTaskChanges(uploadResult.taskId!);
      // }
    }
  }

  ///
  /// Returns the file bytes of either a single file or multiple images concatenated into a single pdf.
  ///
  Future<AssembledFile> _assembleFileBytes(
    final List<File> files, {
    bool forcePdf = false,
  }) async {
    assert(files.isNotEmpty);
    if (files.length == 1 && !forcePdf) {
      final ext = p.extension(files.first.path);
      return AssembledFile(ext, files.first.readAsBytesSync());
    }
    final doc = pw.Document();
    for (final file in files) {
      final img = pw.MemoryImage(file.readAsBytesSync());
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(
            img.width!.toDouble(),
            img.height!.toDouble(),
          ),
          build: (context) => pw.Image(img),
        ),
      );
    }
    return AssembledFile('.pdf', await doc.save());
  }
}

class AssembledFile {
  final String extension;
  final Uint8List bytes;

  AssembledFile(this.extension, this.bytes);
}
