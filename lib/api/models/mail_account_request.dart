//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_mobile/api/models/account_type_enum.dart';
import 'package:paperless_mobile/api/models/imap_security_enum.dart';
import 'package:paperless_mobile/api/models/correspondent_request_set_permissions.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'mail_account_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MailAccountRequest {
  /// Returns a new [MailAccountRequest] instance.
  MailAccountRequest({
    required this.name,

    required this.imapServer,

    this.imapPort,

    this.imapSecurity,

    required this.username,

    required this.password,

    this.characterSet,

    this.isToken,

    this.owner,

    this.setPermissions,

    this.accountType,

    this.expiration,
  });

  @JsonKey(name: r'name', includeIfNull: false)
  final String name;

  @JsonKey(name: r'imap_server', includeIfNull: false)
  final String imapServer;

  /// This is usually 143 for unencrypted and STARTTLS connections, and 993 for SSL connections.
  // minimum: -2147483648
  // maximum: 2147483647
  @JsonKey(name: r'imap_port', includeIfNull: false)
  final int? imapPort;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'imap_security', includeIfNull: false)
  final ImapSecurityEnum? imapSecurity;

  @JsonKey(name: r'username', includeIfNull: false)
  final String username;

  @JsonKey(name: r'password', includeIfNull: false)
  final String password;

  /// The character set to use when communicating with the mail server, such as 'UTF-8' or 'US-ASCII'.
  @JsonKey(name: r'character_set', includeIfNull: false)
  final String? characterSet;

  @JsonKey(name: r'is_token', includeIfNull: false)
  final bool? isToken;

  @JsonKey(name: r'owner', includeIfNull: false)
  final int? owner;

  @JsonKey(name: r'set_permissions', includeIfNull: false)
  final CorrespondentRequestSetPermissions? setPermissions;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'account_type', includeIfNull: false)
  final AccountTypeEnum? accountType;

  /// The expiration date of the refresh token.
  @JsonKey(name: r'expiration', includeIfNull: false)
  final DateTime? expiration;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MailAccountRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [
                name,
                imapServer,
                imapPort,
                imapSecurity,
                username,
                password,
                characterSet,
                isToken,
                owner,
                setPermissions,
                accountType,
                expiration,
              ],
              [
                other.name,
                other.imapServer,
                other.imapPort,
                other.imapSecurity,
                other.username,
                other.password,
                other.characterSet,
                other.isToken,
                other.owner,
                other.setPermissions,
                other.accountType,
                other.expiration,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        name,
        imapServer,
        imapPort,
        imapSecurity,
        username,
        password,
        characterSet,
        isToken,
        owner,
        setPermissions,
        accountType,
        expiration,
      ]);

  factory MailAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$MailAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MailAccountRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
