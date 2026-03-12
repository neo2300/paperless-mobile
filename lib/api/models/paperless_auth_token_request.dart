import 'package:freezed_annotation/freezed_annotation.dart';

part 'paperless_auth_token_request.freezed.dart';
part 'paperless_auth_token_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PaperlessAuthTokenRequest with _$PaperlessAuthTokenRequest {
  factory PaperlessAuthTokenRequest({
    required String username,
    required String password,
    String? code,
  }) = _PaperlessAuthTokenRequest;
}
