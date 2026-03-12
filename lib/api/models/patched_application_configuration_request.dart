import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/color_conversion_strategy_enum.dart';
import 'package:paperless_mobile/api/models/mode_enum.dart';
import 'package:paperless_mobile/api/models/output_type_enum.dart';
import 'package:paperless_mobile/api/models/skip_archive_file_enum.dart';
import 'package:paperless_mobile/api/models/unpaper_clean_enum.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_application_configuration_request.freezed.dart';
part 'patched_application_configuration_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedApplicationConfigurationRequest
    with _$PatchedApplicationConfigurationRequest {
  factory PatchedApplicationConfigurationRequest({
    Option<Object?>? userArgs,
    Option<Object?>? barcodeTagMapping,
    Option<OutputTypeEnum?>? outputType,
    // minimum: 1
    // maximum: 2147483647
    Option<int?>? pages,
    Option<String?>? language,
    Option<ModeEnum?>? mode,
    Option<SkipArchiveFileEnum?>? skipArchiveFile,
    // minimum: 1
    // maximum: 2147483647
    Option<int?>? imageDpi,
    Option<UnpaperCleanEnum?>? unpaperClean,
    Option<bool?>? deskew,
    Option<bool?>? rotatePages,
    // minimum: 0.0
    Option<double?>? rotatePagesThreshold,
    // minimum: 0.0
    Option<double?>? maxImagePixels,
    Option<ColorConversionStrategyEnum?>? colorConversionStrategy,
    Option<String?>? appTitle,
    // @JsonKey(includeToJson: false)
    // Option<MultipartFile?>? appLogo,
    Option<bool?>? barcodesEnabled,
    Option<bool?>? barcodeEnableTiffSupport,
    Option<String?>? barcodeString,
    Option<bool?>? barcodeRetainSplitPages,
    Option<bool?>? barcodeEnableAsn,
    Option<String?>? barcodeAsnPrefix,
    // minimum: 1.0
    Option<double?>? barcodeUpscale,
    // minimum: 1
    // maximum: 2147483647
    Option<int?>? barcodeDpi,
    // minimum: 1
    // maximum: 2147483647
    Option<int?>? barcodeMaxPages,
    Option<bool?>? barcodeEnableTag,
  }) = _PatchedApplicationConfigurationRequest;

  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedApplicationConfigurationRequestToJson(
      this as _PatchedApplicationConfigurationRequest,
    ),
  );
}
