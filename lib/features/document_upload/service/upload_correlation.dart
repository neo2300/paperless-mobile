import 'package:uuid/uuid.dart';

/// Generates a short, non-sensitive correlation identifier for a single
/// document upload attempt (one call to
/// `DocumentUploadPreparationPage._onSubmit`).
///
/// This identifier is threaded through preparation (page count, PDF
/// assembly/write timing), the multipart file read, and the HTTP POST, so
/// the resulting log lines for a single upload attempt can be correlated
/// with each other without logging any document bytes, paths, filenames,
/// titles, tags, credentials, or OCR content — see `paperless_documents_api.dart`
/// and `document_pdf_builder.dart` for where it is actually logged.
///
/// Deliberately short (just the first UUID segment) since this is only
/// ever used to group log lines for a human reading them, not as a durable
/// identifier.
String newUploadCorrelationId() => const Uuid().v4().split('-').first;
