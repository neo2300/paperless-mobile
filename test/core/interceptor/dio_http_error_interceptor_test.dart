import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/api/interceptor/dio_http_error_interceptor.dart';

void main() {
  test('forwards non-400 errors instead of leaving the request pending', () {
    final dio = Dio()..httpClientAdapter = _StatusCodeAdapter(413);
    dio.interceptors.add(DioHttpErrorInterceptor());

    expectLater(
      dio
          .get<void>('/api/documents/post_document/')
          .timeout(const Duration(seconds: 1)),
      throwsA(
        isA<DioException>().having(
          (exception) => exception.response?.statusCode,
          'status code',
          413,
        ),
      ),
    );
  });
}

class _StatusCodeAdapter implements HttpClientAdapter {
  final int statusCode;

  const _StatusCodeAdapter(this.statusCode);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString('', statusCode);
  }

  @override
  void close({bool force = false}) {}
}
