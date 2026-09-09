import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/document_upload/model/document_upload_queue.dart';
import 'package:paperless_mobile/features/document_upload/view/document_upload_preparation_page.dart';

void main() {
  group('dispatchDocumentUploadQueueResult', () {
    test(
      'invokes onUploaded and not onCancelled for a successful result',
      () async {
        var uploadedCallCount = 0;
        var cancelledCallCount = 0;
        final result = DocumentUploadResult(true, 'task-123');

        final dispatchResult = await dispatchDocumentUploadQueueResult(
          result,
          onUploaded: (_) async => uploadedCallCount++,
          onCancelled: () async => cancelledCallCount++,
        );

        expect(uploadedCallCount, equals(1));
        expect(cancelledCallCount, equals(0));
        expect(dispatchResult, DocumentUploadQueueDispatchResult.uploaded);
      },
    );

    test(
      'invokes onCancelled and not onUploaded for a failed result',
      () async {
        var uploadedCallCount = 0;
        var cancelledCallCount = 0;
        final result = DocumentUploadResult(false, null);

        final dispatchResult = await dispatchDocumentUploadQueueResult(
          result,
          onUploaded: (_) async => uploadedCallCount++,
          onCancelled: () async => cancelledCallCount++,
        );

        expect(uploadedCallCount, equals(0));
        expect(cancelledCallCount, equals(1));
        expect(dispatchResult, DocumentUploadQueueDispatchResult.cancelled);
      },
    );

    test('invokes onCancelled and not onUploaded for a null result', () async {
      var uploadedCallCount = 0;
      var cancelledCallCount = 0;

      final dispatchResult = await dispatchDocumentUploadQueueResult(
        null,
        onUploaded: (_) async => uploadedCallCount++,
        onCancelled: () async => cancelledCallCount++,
      );

      expect(uploadedCallCount, equals(0));
      expect(cancelledCallCount, equals(1));
      expect(dispatchResult, DocumentUploadQueueDispatchResult.cancelled);
    });
  });
}
