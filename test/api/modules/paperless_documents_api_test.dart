// Focused tests for the file-read failure classification added to
// `createFromFile`: a raw I/O error reading the caller's prepared upload
// file (missing/unreadable temp file) must become a classified
// `PaperlessApiException(ErrorCode.documentUploadFailed)` instead of
// surfacing as an unclassified error (which would otherwise be reported to
// the UI as `DocumentUploadMutationUnknownError` — see
// `document_upload_mutation_outcome.dart`).
//
// These deliberately never reach the HTTP client (the failure happens
// while reading the local file, strictly before `_postUpload`'s
// `client.post` call), so a bare, unconfigured `Dio()` instance is safe to
// use here without any network mocking.
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:paperless_mobile/api/modules/paperless_documents_api.dart';
import 'package:paperless_mobile/api/models/models.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart' as app_log;

class _TestAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) response;

  const _TestAdapter(this.response);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => response(options);

  @override
  void close({bool force = false}) {}
}

class _RecordingLogOutput extends LogOutput {
  final events = <OutputEvent>[];

  @override
  void output(OutputEvent event) => events.add(event);
}

Dio _dioWithResponse(
  Future<ResponseBody> Function(RequestOptions options) response,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://paperless.invalid'));
  dio.httpClientAdapter = _TestAdapter(response);
  return dio;
}

ResponseBody _textResponse(String value) => ResponseBody.fromString(
  value,
  200,
  headers: {
    Headers.contentTypeHeader: ['text/plain'],
  },
);

void main() {
  late Directory tempDir;
  late PaperlessDocumentsApiImpl api;
  late _RecordingLogOutput logOutput;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('documents_api_test_');
    logOutput = _RecordingLogOutput();
    // The global logger is normally initialized during app bootstrap.
    app_log.logger = Logger(
      printer: SimplePrinter(),
      output: logOutput,
      level: Level.trace,
    );
    api = PaperlessDocumentsApiImpl(Dio());
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('createFromFile classifies a missing prepared file as a '
      'PaperlessApiException(documentUploadFailed) instead of an '
      'unclassified error', () async {
    final missingFile = File('${tempDir.path}/does_not_exist.pdf');
    expect(await missingFile.exists(), isFalse);

    await expectLater(
      api.createFromFile(missingFile, filename: 'does_not_exist.pdf'),
      throwsA(
        isA<PaperlessApiException>()
            .having((e) => e.code, 'code', ErrorCode.documentUploadFailed)
            .having(
              (e) => e.details,
              'sanitized details',
              allOf(isNot(contains(tempDir.path)), 'PathNotFoundException'),
            ),
      ),
    );
    final loggedText = logOutput.events
        .expand((event) => event.lines)
        .join('\n');
    expect(loggedText, isNot(contains(missingFile.path)));
    expect(loggedText, isNot(contains('does_not_exist.pdf')));
  });

  test('createFromFile never reaches the HTTP client for a missing file '
      '(fails during the local file read, not the network request)', () async {
    // A cancelled token proves the request was never actually dispatched:
    // if `client.post` were reached, it would race with (and could throw a
    // different, cancellation-flavored) error instead of the classified
    // file-read exception asserted above.
    final cancelToken = CancelToken();
    cancelToken.cancel('should never be needed');
    final missingFile = File('${tempDir.path}/also_missing.pdf');

    await expectLater(
      api.createFromFile(
        missingFile,
        filename: 'also_missing.pdf',
        cancelToken: cancelToken,
      ),
      throwsA(
        isA<PaperlessApiException>().having(
          (e) => e.code,
          'code',
          ErrorCode.documentUploadFailed,
        ),
      ),
    );
  });

  test('adds storage_path exactly once to upload form data', () async {
    FormData? postedFormData;
    api = PaperlessDocumentsApiImpl(
      _dioWithResponse((options) async {
        postedFormData = options.data as FormData;
        return _textResponse('task-123');
      }),
    );

    final taskId = await api.create(
      Uint8List.fromList([1, 2, 3]),
      filename: 'document.pdf',
      storagePath: 42,
    );

    expect(taskId, 'task-123');
    final storagePathFields = postedFormData!.fields
        .where((field) => field.key == 'storage_path')
        .toList();
    expect(storagePathFields, hasLength(1));
    expect(storagePathFields.single.value, '42');
  });

  test('classifies a null upload response as documentUploadFailed', () async {
    final dio = _dioWithResponse((_) async => _textResponse('ignored'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) => handler.next(
          Response<dynamic>(
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            data: null,
          ),
        ),
      ),
    );
    api = PaperlessDocumentsApiImpl(dio);

    await expectLater(
      api.create(Uint8List(1), filename: 'document.pdf'),
      throwsA(
        isA<PaperlessApiException>().having(
          (error) => error.code,
          'code',
          ErrorCode.documentUploadFailed,
        ),
      ),
    );
  });

  for (final type in [
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
  ]) {
    test('classifies $type as requestTimedOut', () async {
      api = PaperlessDocumentsApiImpl(
        _dioWithResponse((options) async {
          throw DioException(requestOptions: options, type: type);
        }),
      );

      await expectLater(
        api.create(Uint8List(1), filename: 'document.pdf'),
        throwsA(
          isA<PaperlessApiException>().having(
            (error) => error.code,
            'code',
            ErrorCode.requestTimedOut,
          ),
        ),
      );
    });
  }

  test('classifies a Dio connection error as serverUnreachable', () async {
    api = PaperlessDocumentsApiImpl(
      _dioWithResponse((options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        );
      }),
    );

    await expectLater(
      api.create(Uint8List(1), filename: 'document.pdf'),
      throwsA(
        isA<PaperlessApiException>().having(
          (error) => error.code,
          'code',
          ErrorCode.serverUnreachable,
        ),
      ),
    );
  });

  test('classifies a SocketException-backed unknown error as '
      'serverUnreachable', () async {
    api = PaperlessDocumentsApiImpl(
      _dioWithResponse((options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: const SocketException('host unreachable'),
        );
      }),
    );

    await expectLater(
      api.create(Uint8List(1), filename: 'document.pdf'),
      throwsA(
        isA<PaperlessApiException>().having(
          (error) => error.code,
          'code',
          ErrorCode.serverUnreachable,
        ),
      ),
    );
  });

  test('preserves a PaperlessApiException from DioException.error', () async {
    const original = PaperlessApiException(ErrorCode.mfaCodeRequired);
    api = PaperlessDocumentsApiImpl(
      _dioWithResponse((options) async {
        throw DioException(requestOptions: options, error: original);
      }),
    );

    await expectLater(
      api.create(Uint8List(1), filename: 'document.pdf'),
      throwsA(same(original)),
    );
  });

  test('preserves a form-validation error from DioException.error', () async {
    final original = PaperlessFormValidationException({
      'title': 'This field is required.',
    });
    api = PaperlessDocumentsApiImpl(
      _dioWithResponse((options) async {
        throw DioException(requestOptions: options, error: original);
      }),
    );

    await expectLater(
      api.create(Uint8List(1), filename: 'document.pdf'),
      throwsA(same(original)),
    );
  });

  test('preserves Dio cancellation semantics', () async {
    api = PaperlessDocumentsApiImpl(
      _dioWithResponse((options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
        );
      }),
    );

    await expectLater(
      api.create(Uint8List(1), filename: 'document.pdf'),
      throwsA(
        isA<DioException>().having(
          (error) => error.type,
          'type',
          DioExceptionType.cancel,
        ),
      ),
    );
  });
}
