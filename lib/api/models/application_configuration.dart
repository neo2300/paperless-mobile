//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_mobile/api/models/skip_archive_file_enum.dart';
import 'package:paperless_mobile/api/models/unpaper_clean_enum.dart';
import 'package:paperless_mobile/api/models/mode_enum.dart';
import 'package:paperless_mobile/api/models/output_type_enum.dart';
import 'package:paperless_mobile/api/models/color_conversion_strategy_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'application_configuration.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApplicationConfiguration {
  /// Returns a new [ApplicationConfiguration] instance.
  ApplicationConfiguration({
    required this.id,

    required this.userArgs,

    required this.barcodeTagMapping,

    this.outputType,

    this.pages,

    this.language,

    this.mode,

    this.skipArchiveFile,

    this.imageDpi,

    this.unpaperClean,

    this.deskew,

    this.rotatePages,

    this.rotatePagesThreshold,

    this.maxImagePixels,

    this.colorConversionStrategy,

    this.appTitle,

    this.appLogo,

    this.barcodesEnabled,

    this.barcodeEnableTiffSupport,

    this.barcodeString,

    this.barcodeRetainSplitPages,

    this.barcodeEnableAsn,

    this.barcodeAsnPrefix,

    this.barcodeUpscale,

    this.barcodeDpi,

    this.barcodeMaxPages,

    this.barcodeEnableTag,
  });

  @JsonKey(name: r'id', includeIfNull: false)
  final int id;

  @JsonKey(name: r'user_args', includeIfNull: true)
  final Object? userArgs;

  @JsonKey(name: r'barcode_tag_mapping', includeIfNull: true)
  final Object? barcodeTagMapping;

  @JsonKey(name: r'output_type', includeIfNull: false)
  final OutputTypeEnum? outputType;

  // minimum: 1
  // maximum: 2147483647
  @JsonKey(name: r'pages', includeIfNull: false)
  final int? pages;

  @JsonKey(name: r'language', includeIfNull: false)
  final String? language;

  @JsonKey(name: r'mode', includeIfNull: false)
  final ModeEnum? mode;

  @JsonKey(name: r'skip_archive_file', includeIfNull: false)
  final SkipArchiveFileEnum? skipArchiveFile;

  // minimum: 1
  // maximum: 2147483647
  @JsonKey(name: r'image_dpi', includeIfNull: false)
  final int? imageDpi;

  @JsonKey(name: r'unpaper_clean', includeIfNull: false)
  final UnpaperCleanEnum? unpaperClean;

  @JsonKey(name: r'deskew', includeIfNull: false)
  final bool? deskew;

  @JsonKey(name: r'rotate_pages', includeIfNull: false)
  final bool? rotatePages;

  // minimum: 0.0
  @JsonKey(name: r'rotate_pages_threshold', includeIfNull: false)
  final double? rotatePagesThreshold;

  // minimum: 0.0
  @JsonKey(name: r'max_image_pixels', includeIfNull: false)
  final double? maxImagePixels;

  @JsonKey(name: r'color_conversion_strategy', includeIfNull: false)
  final ColorConversionStrategyEnum? colorConversionStrategy;

  @JsonKey(name: r'app_title', includeIfNull: false)
  final String? appTitle;

  @JsonKey(name: r'app_logo', includeIfNull: false)
  final String? appLogo;

  @JsonKey(name: r'barcodes_enabled', includeIfNull: false)
  final bool? barcodesEnabled;

  @JsonKey(name: r'barcode_enable_tiff_support', includeIfNull: false)
  final bool? barcodeEnableTiffSupport;

  @JsonKey(name: r'barcode_string', includeIfNull: false)
  final String? barcodeString;

  @JsonKey(name: r'barcode_retain_split_pages', includeIfNull: false)
  final bool? barcodeRetainSplitPages;

  @JsonKey(name: r'barcode_enable_asn', includeIfNull: false)
  final bool? barcodeEnableAsn;

  @JsonKey(name: r'barcode_asn_prefix', includeIfNull: false)
  final String? barcodeAsnPrefix;

  // minimum: 1.0
  @JsonKey(name: r'barcode_upscale', includeIfNull: false)
  final double? barcodeUpscale;

  // minimum: 1
  // maximum: 2147483647
  @JsonKey(name: r'barcode_dpi', includeIfNull: false)
  final int? barcodeDpi;

  // minimum: 1
  // maximum: 2147483647
  @JsonKey(name: r'barcode_max_pages', includeIfNull: false)
  final int? barcodeMaxPages;

  @JsonKey(name: r'barcode_enable_tag', includeIfNull: false)
  final bool? barcodeEnableTag;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ApplicationConfiguration &&
            runtimeType == other.runtimeType &&
            equals(
              [
                id,
                userArgs,
                barcodeTagMapping,
                outputType,
                pages,
                language,
                mode,
                skipArchiveFile,
                imageDpi,
                unpaperClean,
                deskew,
                rotatePages,
                rotatePagesThreshold,
                maxImagePixels,
                colorConversionStrategy,
                appTitle,
                appLogo,
                barcodesEnabled,
                barcodeEnableTiffSupport,
                barcodeString,
                barcodeRetainSplitPages,
                barcodeEnableAsn,
                barcodeAsnPrefix,
                barcodeUpscale,
                barcodeDpi,
                barcodeMaxPages,
                barcodeEnableTag,
              ],
              [
                other.id,
                other.userArgs,
                other.barcodeTagMapping,
                other.outputType,
                other.pages,
                other.language,
                other.mode,
                other.skipArchiveFile,
                other.imageDpi,
                other.unpaperClean,
                other.deskew,
                other.rotatePages,
                other.rotatePagesThreshold,
                other.maxImagePixels,
                other.colorConversionStrategy,
                other.appTitle,
                other.appLogo,
                other.barcodesEnabled,
                other.barcodeEnableTiffSupport,
                other.barcodeString,
                other.barcodeRetainSplitPages,
                other.barcodeEnableAsn,
                other.barcodeAsnPrefix,
                other.barcodeUpscale,
                other.barcodeDpi,
                other.barcodeMaxPages,
                other.barcodeEnableTag,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        id,
        userArgs,
        barcodeTagMapping,
        outputType,
        pages,
        language,
        mode,
        skipArchiveFile,
        imageDpi,
        unpaperClean,
        deskew,
        rotatePages,
        rotatePagesThreshold,
        maxImagePixels,
        colorConversionStrategy,
        appTitle,
        appLogo,
        barcodesEnabled,
        barcodeEnableTiffSupport,
        barcodeString,
        barcodeRetainSplitPages,
        barcodeEnableAsn,
        barcodeAsnPrefix,
        barcodeUpscale,
        barcodeDpi,
        barcodeMaxPages,
        barcodeEnableTag,
      ]);

  factory ApplicationConfiguration.fromJson(Map<String, dynamic> json) =>
      _$ApplicationConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationConfigurationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
