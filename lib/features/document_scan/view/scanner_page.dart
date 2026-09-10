import 'dart:async';
import 'dart:io';

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
import 'package:paperless_mobile/features/document_scan/model/document_scan.dart';
import 'package:paperless_mobile/features/document_scan/service/scanner_upload_file.dart';
import 'package:paperless_mobile/features/document_scan/view/widgets/export_scans_dialog.dart';
import 'package:paperless_mobile/features/document_scan/view/widgets/scanned_image_item.dart';
import 'package:paperless_mobile/features/document_search/view/sliver_search_bar.dart';
import 'package:paperless_mobile/features/document_upload/model/document_upload_queue.dart';
import 'package:paperless_mobile/features/document_upload/service/document_upload_queue_coordinator.dart';
import 'package:paperless_mobile/features/document_upload/view/document_upload_preparation_page.dart';
import 'package:paperless_mobile/features/documents/view/pages/document_view.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/connectivity_aware_action_wrapper.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/helpers/permission_helpers.dart';
import 'package:paperless_mobile/features/scanner/models/scan_result.dart';
import 'package:paperless_mobile/features/scanner/paperless_mobile_document_scanner.dart';
import 'package:paperless_mobile/features/scanner/processing/document_pdf_builder.dart';
import 'package:paperless_mobile/routing/routes/scanner_route.dart';
import 'package:path/path.dart' as p;
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
                LoadingStatus.loaded => _buildDocumentList(state.documentScans),
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
          final uploadableDocumentScans = state.documentScans
              .where((scan) => scan.pageFiles.isNotEmpty)
              .toList();
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
                      label: Text(S.of(context)!.clearAll),
                      onPressed: state.documentScans.isEmpty
                          ? null
                          : () => _reset(context),
                      avatar: const Icon(Icons.delete_sweep_outlined),
                    ),
                    SizedBox(width: 8),
                    ConnectivityAwareActionWrapper(
                      offlineBuilder: (context, child) {
                        return ActionChip(
                          label: Text(S.of(context)!.uploadAll),
                          onPressed: null,
                          avatar: const Icon(Icons.upload_outlined),
                        );
                      },
                      disabled: uploadableDocumentScans.isEmpty,
                      child: ActionChip(
                        label: Text(S.of(context)!.uploadAll),
                        onPressed: () => _onPrepareDocumentUploadQueue(
                          context,
                          uploadableDocumentScans,
                        ),
                        avatar: const Icon(Icons.upload_outlined),
                      ),
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

  void _onSaveToFile(List<File> scans) async {
    final globalSettings = context.localStore.state.globalSettings;
    final fileName = await showDialog<String>(
      useRootNavigator: false,
      context: context,
      builder: (context) => const ExportScansDialog(),
    );
    if (fileName != null) {
      if (!mounted) return;
      final cubit = context.read<DocumentScannerCubit>();
      final file = await _assembleFileBytes(scans);
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
    DocumentScan documentScan,
    List<ScanResult> pages,
    NavigatorState rootNavigator,
  ) async {
    final cubit = context.read<DocumentScannerCubit>();
    if (pages.isNotEmpty) {
      final shouldDiscard = await showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => AlertDialog(
          title: Text(S.of(context)!.discard),
          content: Text(S.of(context)!.discardScannedDocuments),
          actions: [
            DialogConfirmButton(returnValue: true),
            DialogCancelButton(),
          ],
        ),
      );
      if (shouldDiscard) {
        rootNavigator.pop();
        await cubit.discardDocumentScanDraft(documentScan.id);
      }
    } else {
      rootNavigator.pop();
      await cubit.discardDocumentScanDraft(documentScan.id);
    }
  }

  void _openDocumentScanner(BuildContext context) async {
    final cubit = context.read<DocumentScannerCubit>();
    final rootNavigator = Navigator.of(context, rootNavigator: true);

    final documentScan = await cubit.createDocumentScan(persist: false);
    final result = await rootNavigator.push<List<ScanResult>>(
      MaterialPageRoute(
        builder: (context) => PaperlessMobileDocumentScanner(
          directory: documentScan.directory,
          initialScans: documentScan.pages,
          onCancelled: (files) =>
              _onScanCancelled(documentScan, files, rootNavigator),
          onDone: (files) => rootNavigator.pop(files),
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      await cubit.persistDocumentScan(documentScan.copyWith(pages: result));
    } else {
      await cubit.discardDocumentScanDraft(documentScan.id);
    }
  }

  void _openExistingDocumentScanner(
    BuildContext context,
    DocumentScan documentScan,
  ) async {
    final cubit = context.read<DocumentScannerCubit>();
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    final result = await rootNavigator.push<List<ScanResult>>(
      MaterialPageRoute(
        builder: (context) => PaperlessMobileDocumentScanner(
          directory: documentScan.directory,
          initialScans: documentScan.pages,
          onCancelled: (files) async => rootNavigator.pop(files),
          onDone: (files) => rootNavigator.pop(files),
        ),
      ),
    );

    if (result != null) {
      await cubit.refreshDocumentScanFromScanner(documentScan.id, result);
    }
  }

  void _previewScans(BuildContext context, List<File> scans) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => DocumentView(
          bytes: _assembleFileBytes(scans).then((file) => file.bytes),
        ),
      ),
    );
  }

  Future<void> _previewDocumentScanPage(
    DocumentScan documentScan,
    int pageIndex,
  ) async {
    if (pageIndex < 0 || pageIndex >= documentScan.pages.length) {
      return;
    }

    final editedFile = documentScan.pages[pageIndex].editedFile(
      documentScan.editedDirectory,
    );
    if (!await editedFile.exists()) {
      if (!mounted) return;
      showInfoMessage(
        context,
        InfoMessageException(
          code: ErrorCode.unknown,
          message: 'The selected scan page could not be opened.',
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => DocumentView(bytes: editedFile.readAsBytes()),
      ),
    );
  }

  void _onPrepareDocumentUpload(
    BuildContext context,
    List<File> scans, {
    DocumentScan? documentScan,
  }) async {
    if (!context.mounted) return;
    final userId = context.loggedInUser.appUserId;
    final uploadResult = await Navigator.of(context, rootNavigator: true)
        .push<DocumentUploadResult>(
          MaterialPageRoute(
            builder: (_) => DocumentUploadPreparationPage(
              prepareUploadFile: (correlationId) =>
                  _prepareUploadFile(scans, correlationId, userId),
              previewFile: scans.first,
              fileExtension: _assembledFileExtension,
            ),
          ),
        );
    if (uploadResult?.success ?? false) {
      if (!context.mounted) return;
      final cubit = context.read<DocumentScannerCubit>();
      if (documentScan != null) {
        try {
          await cubit.removeDocumentScan(documentScan);
        } on PaperlessApiException catch (error, stackTrace) {
          if (!context.mounted) return;
          showErrorMessage(context, error, stackTrace);
        } on InfoMessageException catch (error, stackTrace) {
          if (!context.mounted) return;
          showInfoMessage(context, error, stackTrace);
        }
      } else {
        // For paperless version older than 1.11.3, task id will always be null!
        cubit.reset();
      }
    }
  }

  void _onPrepareDocumentUploadQueue(
    BuildContext context,
    List<DocumentScan> documentScans,
  ) async {
    if (documentScans.isEmpty) {
      return;
    }
    final userId = context.loggedInUser.appUserId;

    await DocumentUploadQueueCoordinator.processQueue<DocumentScan>(
      context,
      items: [
        for (final documentScan in documentScans)
          DocumentUploadQueueItem(
            source: documentScan,
            // Only used by legacy byte-only callers. Scanner uploads below
            // use [prepareUploadFile] and never use these bytes as source.
            loadFileBytes: documentScan.pageFiles.first.readAsBytes,
            prepareUploadFile: (correlationId) => _prepareUploadFile(
              documentScan.pageFiles,
              correlationId,
              userId,
            ),
            previewFile: documentScan.coverFile,
            title: documentScan.name,
            filename: _formatUploadFileName(documentScan.name),
            fileExtension: _assembledFileExtension,
          ),
      ],
      delegate: const _DocumentScanUploadQueueDelegate(),
    );
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

  Widget _buildDocumentList(List<DocumentScan> documentScans) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          SliverOverlapInjector(handle: searchBarHandle),
          SliverOverlapInjector(handle: actionsHandle),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 12),
            sliver: SliverList.builder(
              itemCount: documentScans.length,
              itemBuilder: (context, index) {
                final documentScan = documentScans[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ScannedImageItem(
                    documentScan: documentScan,
                    onEdit: () =>
                        _openExistingDocumentScanner(context, documentScan),
                    onPageTap: (pageIndex) =>
                        _previewDocumentScanPage(documentScan, pageIndex),
                    onPreview: documentScan.pageFiles.isEmpty
                        ? null
                        : () => _previewScans(context, documentScan.pageFiles),
                    onUpload: documentScan.pageFiles.isEmpty
                        ? null
                        : () => _onPrepareDocumentUpload(
                            context,
                            documentScan.pageFiles,
                            documentScan: documentScan,
                          ),
                    onExport: documentScan.pageFiles.isEmpty
                        ? null
                        : () => _onSaveToFile(documentScan.pageFiles),
                    onDelete: () async {
                      final cubit = context.read<DocumentScannerCubit>();
                      try {
                        await cubit.removeDocumentScan(documentScan);
                      } on PaperlessApiException catch (error, stackTrace) {
                        if (!context.mounted) return;
                        showErrorMessage(context, error, stackTrace);
                      } on InfoMessageException catch (error, stackTrace) {
                        if (!context.mounted) return;
                        showInfoMessage(context, error, stackTrace);
                      }
                    },
                  ),
                );
              },
            ),
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
        $extra: file.readAsBytes(),
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
  /// Assembles the given scanned page image files into a single PDF's
  /// bytes. Scanner uploads are always a PDF, including a single page.
  ///
  Future<AssembledFile> _assembleFileBytes(final List<File> files) async {
    assert(files.isNotEmpty);
    final bytes = await compute(assembleDocumentPdfBytes, [
      for (final file in files) file.path,
    ]);
    return AssembledFile(_assembledFileExtension, bytes);
  }
}

/// Scanner uploads are always assembled as a PDF, including a single page,
/// so this never branches on the page count (or on the now-unused
/// `enforceSinglePagePdfUpload` setting).
const String _assembledFileExtension = '.pdf';

/// Allocates the transient output file in the current user's app-managed
/// consumption directory, then hands its path to
/// [assembleAndWriteDocumentPdfToFile] to run (via `compute`, in a worker
/// isolate) and write the assembled PDF bytes *directly* to that file from
/// within the worker isolate — see that function's doc comment for why
/// this avoids transferring the full PDF `Uint8List` back to this (UI)
/// isolate, unlike the previous "assemble bytes here, then write them"
/// approach. The upload directory is used instead of the OS-managed cache so
/// the file remains a safe handoff to Dio's lazily consumed multipart stream.
/// On any assembly/write failure the partial upload file is
/// deleted before the error is rethrown.
///
/// Logs are intentionally limited to non-sensitive metadata (page count,
/// timing, resulting byte length/page count) tagged with [correlationId]
/// so they can be correlated with the subsequent multipart-upload logs in
/// `paperless_documents_api.dart` without ever logging document bytes,
/// paths, filenames, titles, tags, or OCR content.
Future<PreparedUploadFile> _prepareUploadFile(
  List<File> files,
  String correlationId,
  String userId,
) async {
  final stopwatch = Stopwatch()..start();
  logger.fi(
    'Upload[$correlationId]: PDF assembly started (pageCount=${files.length})',
    className: 'scanner_page',
    methodName: '_prepareUploadFile',
  );
  try {
    return await createScannerUploadFile(
      userId: userId,
      write: (file) async {
        final result = await compute(assembleAndWriteDocumentPdfToFile, (
          filePaths: [for (final pageFile in files) pageFile.path],
          outputPath: file.path,
        ));
        logger.fi(
          'Upload[$correlationId]: PDF assembly + upload write completed in '
          '${stopwatch.elapsedMilliseconds}ms '
          '(pdfByteLength=${result.byteLength}, '
          'pdfPageCount=${result.pageCount})',
          className: 'scanner_page',
          methodName: '_prepareUploadFile',
        );
      },
    );
  } catch (error, stackTrace) {
    logger.fe(
      'Upload[$correlationId]: PDF assembly failed after '
      '${stopwatch.elapsedMilliseconds}ms (stage=assembly, '
      'errorType=${error.runtimeType})',
      className: 'scanner_page',
      methodName: '_prepareUploadFile',
      stackTrace: stackTrace,
    );
    throw PaperlessApiException(
      ErrorCode.documentUploadFailed,
      details: error.runtimeType.toString(),
    );
  }
}

String _formatUploadFileName(String source) {
  return source.replaceAll(RegExp(r'[\W_]'), '_').toLowerCase();
}

class _DocumentScanUploadQueueDelegate
    implements DocumentUploadQueueDelegate<DocumentScan> {
  const _DocumentScanUploadQueueDelegate();

  @override
  Future<void> onQueueCompleted(BuildContext context) async {}

  @override
  Future<void> onItemUploaded(
    BuildContext context,
    DocumentUploadQueueItem<DocumentScan> item,
    DocumentUploadResult result,
  ) async {
    final cubit = context.read<DocumentScannerCubit>();
    try {
      await cubit.removeDocumentScan(item.source);
    } on PaperlessApiException catch (error, stackTrace) {
      if (!context.mounted) return;
      showErrorMessage(context, error, stackTrace);
    } on InfoMessageException catch (error, stackTrace) {
      if (!context.mounted) return;
      showInfoMessage(context, error, stackTrace);
    }
  }

  @override
  Future<DocumentUploadQueueCancellationDisposition> onQueueCancelled(
    BuildContext context,
    List<DocumentUploadQueueItem<DocumentScan>> remainingItems,
  ) async {
    return DocumentUploadQueueCancellationDisposition.keepRemaining;
  }

  @override
  Future<void> discardRemainingItems(
    BuildContext context,
    List<DocumentUploadQueueItem<DocumentScan>> remainingItems,
  ) async {
    final cubit = context.read<DocumentScannerCubit>();
    for (final item in remainingItems) {
      try {
        await cubit.removeDocumentScan(item.source);
      } on PaperlessApiException catch (error, stackTrace) {
        if (!context.mounted) return;
        showErrorMessage(context, error, stackTrace);
      } on InfoMessageException catch (error, stackTrace) {
        if (!context.mounted) return;
        showInfoMessage(context, error, stackTrace);
      }
    }
  }
}

class AssembledFile {
  final String extension;
  final Uint8List bytes;

  AssembledFile(this.extension, this.bytes);
}
