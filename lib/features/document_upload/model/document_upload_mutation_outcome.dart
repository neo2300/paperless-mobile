import 'package:paperless_mobile/api/paperless_api.dart';

/// Pure representation of the result of the document creation mutation
/// performed while preparing an upload in
/// `DocumentUploadPreparationPage`.
///
/// `cached_query`'s `Mutation.mutate()` does **not** rethrow errors that
/// occur inside the `mutationFn`. Instead they are captured on the returned
/// `MutationState`, whose base type exposes them via `isError`, `error` and
/// `data`. The original `stackTrace` is only available on the `MutationError`
/// subtype, so callers must narrow the state to `MutationError` themselves
/// before passing a `stackTrace` in.
/// [classifyDocumentUploadMutationOutcome] turns those raw, nullable fields
/// into a well-defined [DocumentUploadMutationOutcome] so callers (and
/// tests) don't have to deal with the raw state directly and don't
/// accidentally treat a failed mutation as successful.
sealed class DocumentUploadMutationOutcome {
  const DocumentUploadMutationOutcome();
}

/// The mutation completed without an error. [taskId] may still be `null` if
/// the server did not report one, but the mutation itself did not fail.
class DocumentUploadMutationSuccess extends DocumentUploadMutationOutcome {
  final String? taskId;

  const DocumentUploadMutationSuccess(this.taskId);

  @override
  bool operator ==(Object other) =>
      other is DocumentUploadMutationSuccess && other.taskId == taskId;

  @override
  int get hashCode => Object.hash(DocumentUploadMutationSuccess, taskId);
}

/// The mutation failed with a [PaperlessFormValidationException], i.e. the
/// server rejected one or more form fields.
class DocumentUploadMutationFormValidationError
    extends DocumentUploadMutationOutcome {
  final PaperlessFormValidationException exception;

  const DocumentUploadMutationFormValidationError(this.exception);
}

/// The mutation failed with a [PaperlessApiException].
class DocumentUploadMutationPaperlessError
    extends DocumentUploadMutationOutcome {
  final PaperlessApiException exception;

  const DocumentUploadMutationPaperlessError(this.exception);
}

/// The mutation failed with an error of an unexpected/unknown type.
class DocumentUploadMutationUnknownError extends DocumentUploadMutationOutcome {
  final Object error;
  final StackTrace stackTrace;

  const DocumentUploadMutationUnknownError(this.error, this.stackTrace);
}

/// Classifies the outcome of a document upload mutation based on the raw
/// fields exposed by the resulting `MutationState`.
///
/// This is a pure function with no dependency on `BuildContext` or the
/// widget tree, which allows it to be unit tested in isolation.
DocumentUploadMutationOutcome classifyDocumentUploadMutationOutcome({
  required bool isError,
  required String? data,
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!isError) {
    return DocumentUploadMutationSuccess(data);
  }
  if (error is PaperlessFormValidationException) {
    return DocumentUploadMutationFormValidationError(error);
  }
  if (error is PaperlessApiException) {
    return DocumentUploadMutationPaperlessError(error);
  }
  return DocumentUploadMutationUnknownError(
    error ?? StateError('Upload mutation failed without an error object.'),
    stackTrace ?? StackTrace.current,
  );
}
