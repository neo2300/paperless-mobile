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
