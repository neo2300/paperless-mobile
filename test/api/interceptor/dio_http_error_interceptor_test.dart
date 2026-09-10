import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/api/interceptor/dio_http_error_interceptor.dart';
import 'package:paperless_mobile/api/models/exception/exception.dart';

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

Dio _dioWithAdapter(_TestAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://paperless.invalid'));
  dio.httpClientAdapter = adapter;
  dio.interceptors.add(DioHttpErrorInterceptor());
  return dio;
}

ResponseBody _jsonResponse(int statusCode, String body) =>
    ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  for (final statusCode in [413, 500]) {
    test('forwards HTTP $statusCode exactly once instead of hanging', () async {
      final dio = _dioWithAdapter(
        _TestAdapter((_) async => _jsonResponse(statusCode, '{}')),
      );

      await expectLater(
        dio.get<void>('/failure').timeout(const Duration(seconds: 1)),
        throwsA(
          isA<DioException>().having(
            (error) => error.response?.statusCode,
            'statusCode',
            statusCode,
          ),
        ),
      );
    });
  }

  test(
    'forwards a connection timeout exactly once instead of hanging',
    () async {
      final dio = _dioWithAdapter(
        _TestAdapter((options) async {
          throw DioException.connectionTimeout(
            timeout: const Duration(seconds: 1),
            requestOptions: options,
          );
        }),
      );

      await expectLater(
        dio.get<void>('/timeout').timeout(const Duration(seconds: 1)),
        throwsA(
          isA<DioException>().having(
            (error) => error.type,
            'type',
            DioExceptionType.connectionTimeout,
          ),
        ),
      );
    },
  );

  test('still maps an existing 400 error response', () async {
    final dio = _dioWithAdapter(
      _TestAdapter(
        (_) async => _jsonResponse(400, '{"error":"invalid upload"}'),
      ),
    );

    await expectLater(
      dio.post<void>('/failure'),
      throwsA(
        isA<DioException>().having(
          (error) => error.error,
          'mapped error',
          isA<PaperlessApiException>()
              .having((error) => error.code, 'code', ErrorCode.unknown)
              .having((error) => error.details, 'details', 'invalid upload'),
        ),
      ),
    );
  });
}
