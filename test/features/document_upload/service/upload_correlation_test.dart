import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/document_upload/service/upload_correlation.dart';

void main() {
  test('newUploadCorrelationId returns a non-empty, non-sensitive id', () {
    final id = newUploadCorrelationId();
    expect(id, isNotEmpty);
    // Short: only ever used to group human-readable log lines.
    expect(id.length, lessThan(20));
  });

  test('newUploadCorrelationId returns a different id on each call', () {
    final ids = {for (var i = 0; i < 20; i++) newUploadCorrelationId()};
    expect(ids, hasLength(20));
  });
}
