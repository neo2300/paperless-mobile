import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:paperless_mobile/features/document_upload/view/document_upload_preparation_page.dart';

class PreparedUploadFile {
  final File file;
  final String extension;
  final bool deleteAfterUpload;

  const PreparedUploadFile({
    required this.file,
    required this.extension,
    this.deleteAfterUpload = false,
  });
}

class DocumentUploadQueueProgress {
  final int currentItem;
  final int totalItems;

  const DocumentUploadQueueProgress({
    required this.currentItem,
    required this.totalItems,
  });

  bool get hasNext => currentItem < totalItems;

  bool get isQueued => totalItems > 1;
}

class DocumentUploadQueueItem<T> {
  final T source;
  final FutureOr<Uint8List> Function() loadFileBytes;
  final FutureOr<PreparedUploadFile> Function()? prepareUploadFile;
  final File? previewFile;
  final String? title;
  final String? filename;
  final String? fileExtension;
  final bool instantUpload;

  const DocumentUploadQueueItem({
    required this.source,
    required this.loadFileBytes,
    this.prepareUploadFile,
    this.previewFile,
    this.title,
    this.filename,
    this.fileExtension,
    this.instantUpload = false,
  });
}

/// The outcome of dispatching a single [DocumentUploadResult] via
/// [dispatchDocumentUploadQueueResult].
enum DocumentUploadQueueDispatchResult { uploaded, cancelled }

/// Invokes [onUploaded] when [result] represents a successful upload, or
/// [onCancelled] otherwise (including when [result] is `null`, i.e. the
/// upload page was popped without completing an upload).
///
/// This is the single source of truth for the "only a successful result
/// triggers `onItemUploaded`" behaviour used by
/// `DocumentUploadQueueCoordinator.processQueue`, extracted as a small,
/// callback-based dispatcher so it can be verified with a focused unit test
/// without requiring the full provider tree needed to actually push and run
/// the upload page.
Future<DocumentUploadQueueDispatchResult> dispatchDocumentUploadQueueResult(
  DocumentUploadResult? result, {
  required Future<void> Function(DocumentUploadResult result) onUploaded,
  required Future<void> Function() onCancelled,
}) async {
  if (result?.success ?? false) {
    await onUploaded(result!);
    return DocumentUploadQueueDispatchResult.uploaded;
  }
  await onCancelled();
  return DocumentUploadQueueDispatchResult.cancelled;
}

enum DocumentUploadQueueCancellationDisposition {
  keepRemaining,
  discardRemaining,
}

abstract interface class DocumentUploadQueueDelegate<T> {
  Future<void> onItemUploaded(
    BuildContext context,
    DocumentUploadQueueItem<T> item,
    DocumentUploadResult result,
  );

  Future<DocumentUploadQueueCancellationDisposition> onQueueCancelled(
    BuildContext context,
    List<DocumentUploadQueueItem<T>> remainingItems,
  );

  Future<void> discardRemainingItems(
    BuildContext context,
    List<DocumentUploadQueueItem<T>> remainingItems,
  );

  Future<void> onQueueCompleted(BuildContext context) async {}
}
