import 'package:dio/dio.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/api/models/exception/exception.dart';

const _mfaCodeRequiredMessage = 'MFA code is required';
const _missingClientCertificateMessage = 'No required SSL certificate was sent';

class DioHttpErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode != 400) {
      return handler.next(err);
    }

    final data = err.response!.data;
    if (data is Map && data.length == 1 && data.containsKey('error')) {
      final message = data['error'] is List
          ? (data['error'] as List).firstOrNull.toString()
          : data['error'].toString();
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          message: message,
          error: PaperlessApiException.unknown(details: message),
          response: err.response,
          stackTrace: err.stackTrace,
          type: DioExceptionType.badResponse,
        ),
      );
    }
    if (PaperlessServerMessageException.canParse(data)) {
      final exception = PaperlessServerMessageException.fromJson(data);
      return handler.reject(
        DioException(
          message: exception.detail,
          requestOptions: err.requestOptions,
          error: exception,
          response: err.response,
          type: DioExceptionType.badResponse,
        ),
      );
    }
    if (PaperlessFormValidationException.canParse(data)) {
      final exception = PaperlessFormValidationException.fromJson(data);
      if (exception.hasUnspecificErrorMessage()) {
        final message = exception.unspecificErrorMessage();
        if (message == _mfaCodeRequiredMessage) {
          return handler.reject(
            DioException(
              message: message,
              requestOptions: err.requestOptions,
              error: PaperlessApiException(ErrorCode.mfaCodeRequired),
              response: err.response,
              type: DioExceptionType.badResponse,
            ),
          );
        }
      }
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: exception,
          response: err.response,
          type: DioExceptionType.badResponse,
        ),
      );
    }
    if (data is String) {
      if (data.contains(_missingClientCertificateMessage)) {
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            type: DioExceptionType.badResponse,
            error: const PaperlessApiException(
              ErrorCode.missingClientCertificate,
            ),
          ),
        );
      }
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          message: data,
          error: PaperlessApiException(
            ErrorCode.documentLoadFailed,
            details: data,
          ),
          response: err.response,
          stackTrace: err.stackTrace,
          type: DioExceptionType.badResponse,
        ),
      );
    }
    return handler.next(err);
  }
}
