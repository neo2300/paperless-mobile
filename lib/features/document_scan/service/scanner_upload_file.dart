import 'dart:io';

import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:paperless_mobile/features/document_upload/model/document_upload_queue.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

typedef ScannerConsumptionDirectoryProvider =
    Future<Directory> Function({required String userId});

/// Allocates and writes an assembled scanner upload in the current user's
/// app-managed consumption directory.
///
/// The writer may complete well before Dio consumes the file-backed multipart
/// stream, so the handoff must not use the OS-evictable cache directory. The
/// returned file is owned by the upload attempt and must be removed with
/// [PreparedUploadFile.deleteIfOwned] in a `finally` block.
Future<PreparedUploadFile> createScannerUploadFile({
  required String userId,
  required Future<void> Function(File outputFile) write,
  ScannerConsumptionDirectoryProvider? getConsumptionDirectory,
}) async {
  final directory =
      await (getConsumptionDirectory ??
          FileService.instance.getConsumptionDirectory)(userId: userId);
  final file = File(p.join(directory.path, '${const Uuid().v1()}.pdf'));
  await file.create(recursive: true, exclusive: true);
  try {
    await write(file);
  } catch (_) {
    try {
      await file.delete();
    } catch (_) {
      // Cleanup must not replace the preparation error.
    }
    rethrow;
  }
  return PreparedUploadFile(
    file: file,
    extension: '.pdf',
    deleteAfterUpload: true,
  );
}
