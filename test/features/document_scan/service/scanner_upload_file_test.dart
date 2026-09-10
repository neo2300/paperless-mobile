import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:paperless_mobile/api/modules/paperless_documents_api.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:paperless_mobile/features/document_scan/service/scanner_upload_file.dart';
import 'package:paperless_mobile/features/document_upload/model/document_upload_queue.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart' as app_log;
import 'package:path/path.dart' as p;

class _DelayedConsumingAdapter implements HttpClientAdapter {
  final Future<void> Function() beforeConsume;
  final Completer<void> requestReady;
  final Completer<void> consumeRequest;
  int consumedByteCount = 0;

  _DelayedConsumingAdapter({
    required this.beforeConsume,
    required this.requestReady,
    required this.consumeRequest,
  });

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestReady.complete();
    await consumeRequest.future;
    await beforeConsume();
    await for (final chunk in requestStream!) {
      consumedByteCount += chunk.length;
    }
    return ResponseBody.fromString(
      'task-delayed',
      200,
      headers: {
        Headers.contentTypeHeader: ['text/plain'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _DiscardLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  late Directory rootDirectory;
  late Directory cacheDirectory;
  late Directory uploadDirectory;
  late Directory appDocumentsDirectory;

  setUp(() async {
    rootDirectory = await Directory.systemTemp.createTemp(
      'scanner_upload_file_test_',
    );
    cacheDirectory = await Directory(
      p.join(rootDirectory.path, 'os_cache'),
    ).create(recursive: true);
    appDocumentsDirectory = await Directory(
      p.join(rootDirectory.path, 'app_documents'),
    ).create(recursive: true);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
          return switch (call.method) {
            'getTemporaryDirectory' => cacheDirectory.path,
            'getApplicationDocumentsDirectory' => appDocumentsDirectory.path,
            _ => null,
          };
        });
    app_log.logger = Logger(
      printer: SimplePrinter(),
      output: _DiscardLogOutput(),
      level: Level.trace,
    );
    await FileService.instance.initialize();
    uploadDirectory = FileService.instance.uploadDirectory;
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    if (await rootDirectory.exists()) {
      await rootDirectory.delete(recursive: true);
    }
  });

  test('uses durable upload storage until delayed large multipart consumption '
      'finishes, then allows explicit cleanup', () async {
    const payloadByteCount = 6 * 1024 * 1024;
    const userId = 'scanner-user';
    final preparedFile = await createScannerUploadFile(
      userId: userId,
      write: (outputFile) async {
        final sink = outputFile.openWrite();
        final chunk = Uint8List(1024 * 1024);
        for (var i = 0; i < payloadByteCount ~/ chunk.length; i++) {
          sink.add(chunk);
        }
        await sink.close();
      },
    );

    final userDirectory = await FileService.instance.getConsumptionDirectory(
      userId: userId,
    );
    expect(p.isWithin(userDirectory.path, preparedFile.file.path), isTrue);
    expect(p.extension(preparedFile.file.path), '.pdf');
    expect(await preparedFile.file.exists(), isTrue);
    expect(await preparedFile.file.length(), payloadByteCount);

    final requestReady = Completer<void>();
    final consumeRequest = Completer<void>();
    final adapter = _DelayedConsumingAdapter(
      requestReady: requestReady,
      consumeRequest: consumeRequest,
      beforeConsume: () async {
        expect(await preparedFile.file.exists(), isTrue);
      },
    );
    final dio = Dio(BaseOptions(baseUrl: 'https://paperless.invalid'));
    dio.httpClientAdapter = adapter;
    final api = PaperlessDocumentsApiImpl(dio);

    try {
      final upload = api.createFromFile(
        preparedFile.file,
        filename: 'prepared.pdf',
      );
      await requestReady.future;

      // Simulate the OS purging its cache after multipart construction but
      // before Dio starts reading the lazy file stream.
      await cacheDirectory.delete(recursive: true);
      expect(await preparedFile.file.exists(), isTrue);

      consumeRequest.complete();
      expect(await upload, 'task-delayed');
      expect(adapter.consumedByteCount, greaterThan(payloadByteCount));
    } finally {
      if (!consumeRequest.isCompleted) consumeRequest.complete();
      await preparedFile.deleteIfOwned();
    }

    expect(await preparedFile.file.exists(), isFalse);
  });

  test('removes a partial durable file when preparation fails', () async {
    late File outputFile;

    await expectLater(
      createScannerUploadFile(
        userId: 'scanner-user',
        write: (file) async {
          outputFile = file;
          await file.writeAsBytes([1, 2, 3]);
          throw StateError('assembly failed');
        },
      ),
      throwsStateError,
    );

    expect(await outputFile.exists(), isFalse);
  });

  test('uses unique filenames in the requested user directory', () async {
    const userId = 'scanner-user';
    final first = await createScannerUploadFile(
      userId: userId,
      write: (file) => file.writeAsBytes([1]),
    );
    final second = await createScannerUploadFile(
      userId: userId,
      write: (file) => file.writeAsBytes([2]),
    );
    final userDirectory = await FileService.instance.getConsumptionDirectory(
      userId: userId,
    );

    try {
      expect(p.dirname(first.file.path), userDirectory.path);
      expect(p.dirname(second.file.path), userDirectory.path);
      expect(p.basename(first.file.path), isNot(p.basename(second.file.path)));
    } finally {
      await first.deleteIfOwned();
      await second.deleteIfOwned();
    }
  });

  test(
    'clearUserData reclaims an orphan without clearing unrelated uploads',
    () async {
      const userId = 'scanner-user';
      final orphan = await createScannerUploadFile(
        userId: userId,
        write: (file) => file.writeAsBytes([1, 2, 3]),
      );
      final unrelatedUpload = File(
        p.join(uploadDirectory.path, 'caller-owned-upload.pdf'),
      );
      await unrelatedUpload.writeAsBytes([4, 5, 6]);

      await FileService.instance.clearUserData(userId: userId);

      expect(await orphan.file.exists(), isFalse);
      expect(await unrelatedUpload.exists(), isTrue);
    },
  );

  test('does not delete caller-owned upload files', () async {
    final file = File(p.join(uploadDirectory.path, 'caller-owned.pdf'));
    await file.writeAsBytes([1]);
    final preparedFile = PreparedUploadFile(file: file, extension: '.pdf');

    await preparedFile.deleteIfOwned();

    expect(await file.exists(), isTrue);
  });
}
