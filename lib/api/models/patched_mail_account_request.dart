import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/account_type_enum.dart';
import 'package:paperless_mobile/api/models/correspondent_request_set_permissions.dart';
import 'package:paperless_mobile/api/models/imap_security_enum.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_mail_account_request.freezed.dart';
part 'patched_mail_account_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedMailAccountRequest with _$PatchedMailAccountRequest {
  factory PatchedMailAccountRequest({
    Option<String?>? name,
    Option<String?>? imapServer,

    /// This is usually 143 for unencrypted and STARTTLS connections, and 993 for SSL connections.
    // minimum: -2147483648
    // maximum: 2147483647
    Option<int?>? imapPort,
    // minimum: 0.0
    // maximum: 2.147483647E9
    Option<ImapSecurityEnum?>? imapSecurity,
    Option<String?>? username,
    Option<String?>? password,

    /// The character set to use when communicating with the mail server, such as 'UTF-8' or 'US-ASCII'.
    Option<String?>? characterSet,
    Option<bool?>? isToken,
    Option<int?>? owner,
    Option<CorrespondentRequestSetPermissions?>? setPermissions,
    // minimum: 0.0
    // maximum: 2.147483647E9
    Option<AccountTypeEnum?>? accountType,

    /// The expiration date of the refresh token.
    Option<DateTime?>? expiration,
  }) = _PatchedMailAccountRequest;

  @override
  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedMailAccountRequestToJson(this as _PatchedMailAccountRequest),
  );
}
