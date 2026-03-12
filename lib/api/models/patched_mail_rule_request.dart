import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/assign_correspondent_from_enum.dart';
import 'package:paperless_mobile/api/models/assign_title_from_enum.dart';
import 'package:paperless_mobile/api/models/attachment_type_enum.dart';
import 'package:paperless_mobile/api/models/consumption_scope_enum.dart';
import 'package:paperless_mobile/api/models/correspondent_request_set_permissions.dart';
import 'package:paperless_mobile/api/models/mail_rule_action_enum.dart';
import 'package:paperless_mobile/api/models/pdf_layout_enum.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_mail_rule_request.freezed.dart';
part 'patched_mail_rule_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedMailRuleRequest with _$PatchedMailRuleRequest {
  factory PatchedMailRuleRequest({
    Option<String?>? name,
    Option<int?>? account,
    Option<bool?>? enabled,

    /// Subfolders must be separated by a delimiter, often a dot ('.') or slash ('/'), but it varies by mail server.
    Option<String?>? folder,
    Option<String?>? filterFrom,
    Option<String?>? filterTo,
    Option<String?>? filterSubject,
    Option<String?>? filterBody,

    /// Only consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
    Option<String?>? filterAttachmentFilenameInclude,

    /// Do not consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
    Option<String?>? filterAttachmentFilenameExclude,

    /// Specified in days.
    // minimum: 0
    // maximum: 2147483647
    Option<int?>? maximumAge,
    // minimum: 0.0
    // maximum: 2.147483647E9
    Option<MailRuleActionEnum?>? action,
    Option<String?>? actionParameter,
    // minimum: 0.0
    // maximum: 2.147483647E9
    Option<AssignTitleFromEnum?>? assignTitleFrom,
    Option<List<int>?>? assignTags,
    // minimum: 0.0
    // maximum: 2.147483647E9
    Option<AssignCorrespondentFromEnum?>? assignCorrespondentFrom,
    Option<int?>? assignCorrespondent,
    Option<int?>? assignDocumentType,
    Option<bool?>? assignOwnerFromRule,
    Option<int?>? order,

    /// Inline attachments include embedded images, so it's best to combine this option with a filename filter.  * `1` - Only process attachments. * `2` - Process all files, including 'inline' attachments.
    // minimum: 0.0
    // maximum: 2.147483647E9
    Option<AttachmentTypeEnum?>? attachmentType,
    // minimum: 0.0
    // maximum: 2.147483647E9
    Option<ConsumptionScopeEnum?>? consumptionScope,
    // minimum: 0.0
    // maximum: 2.147483647E9
    Option<PdfLayoutEnum?>? pdfLayout,
    Option<int?>? owner,
    Option<CorrespondentRequestSetPermissions?>? setPermissions,
  }) = _PatchedMailRuleRequest;

  @override
  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedMailRuleRequestToJson(this as _PatchedMailRuleRequest),
  );
}
