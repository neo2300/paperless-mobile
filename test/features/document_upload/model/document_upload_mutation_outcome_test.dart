import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/features/document_upload/model/document_upload_mutation_outcome.dart';

void main() {
  group('classifyDocumentUploadMutationOutcome', () {
    test('returns success with taskId when mutation did not error', () {
      final outcome = classifyDocumentUploadMutationOutcome(
        isError: false,
        data: 'task-123',
      );

      expect(outcome, isA<DocumentUploadMutationSuccess>());
      expect(
        (outcome as DocumentUploadMutationSuccess).taskId,
        equals('task-123'),
      );
    });

    test('returns success with null taskId when data is null', () {
      final outcome = classifyDocumentUploadMutationOutcome(
        isError: false,
        data: null,
      );

      expect(outcome, isA<DocumentUploadMutationSuccess>());
      expect((outcome as DocumentUploadMutationSuccess).taskId, isNull);
    });

    test(
      'classifies a PaperlessFormValidationException as a form validation error',
      () {
        final exception = PaperlessFormValidationException({
          'title': 'This field is required.',
        });

        final outcome = classifyDocumentUploadMutationOutcome(
          isError: true,
          data: null,
          error: exception,
        );

        expect(outcome, isA<DocumentUploadMutationFormValidationError>());
        expect(
          (outcome as DocumentUploadMutationFormValidationError).exception,
          same(exception),
        );
      },
    );

    test('classifies a PaperlessApiException as a paperless error', () {
      const exception = PaperlessApiException(
        ErrorCode.documentUploadFailed,
        details: 'boom',
      );

      final outcome = classifyDocumentUploadMutationOutcome(
        isError: true,
        data: null,
        error: exception,
      );

      expect(outcome, isA<DocumentUploadMutationPaperlessError>());
      expect(
        (outcome as DocumentUploadMutationPaperlessError).exception,
        same(exception),
      );
    });

    test('classifies a cancelled DioException as cancelled', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/api/documents/post_document/'),
        type: DioExceptionType.cancel,
      );

      final outcome = classifyDocumentUploadMutationOutcome(
        isError: true,
        data: null,
        error: exception,
      );

      expect(outcome, isA<DocumentUploadMutationCancelled>());
    });

    test(
      'classifies a non-cancel DioException as unknown and preserves it',
      () {
        final exception = DioException(
          requestOptions: RequestOptions(path: '/api/documents/post_document/'),
          type: DioExceptionType.connectionTimeout,
        );
        final stackTrace = StackTrace.current;

        final outcome = classifyDocumentUploadMutationOutcome(
          isError: true,
          data: null,
          error: exception,
          stackTrace: stackTrace,
        );

        expect(outcome, isA<DocumentUploadMutationUnknownError>());
        final unknown = outcome as DocumentUploadMutationUnknownError;
        expect(unknown.error, same(exception));
        expect(unknown.stackTrace, same(stackTrace));
      },
    );

    test('classifies any other error as an unknown error and preserves it', () {
      final error = StateError('unexpected');
      final stackTrace = StackTrace.current;

      final outcome = classifyDocumentUploadMutationOutcome(
        isError: true,
        data: null,
        error: error,
        stackTrace: stackTrace,
      );

      expect(outcome, isA<DocumentUploadMutationUnknownError>());
      final unknown = outcome as DocumentUploadMutationUnknownError;
      expect(unknown.error, same(error));
      expect(unknown.stackTrace, same(stackTrace));
    });

    test(
      'classifies a missing error object as an unknown error without throwing',
      () {
        final outcome = classifyDocumentUploadMutationOutcome(
          isError: true,
          data: null,
        );

        expect(outcome, isA<DocumentUploadMutationUnknownError>());
        final unknown = outcome as DocumentUploadMutationUnknownError;
        expect(unknown.error, isNotNull);
        expect(unknown.stackTrace, isNotNull);
      },
    );

    test('does not classify as success when isError is true', () {
      final outcome = classifyDocumentUploadMutationOutcome(
        isError: true,
        data: 'task-123',
        error: Exception('should still be treated as error'),
      );

      expect(outcome, isNot(isA<DocumentUploadMutationSuccess>()));
    });
  });
}
