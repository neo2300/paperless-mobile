import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

part 'label.freezed.dart';

///
/// Utility wrapper class for labels.
///
@freezed
sealed class Label<T> with _$Label<T> {
  Label._();

  factory Label.correspondent(Correspondent value) = _Correspondent;
  factory Label.documentType(DocumentType value) = _DocumentType;
  factory Label.tag(Tag value) = _Tag;
  factory Label.storagePath(StoragePath value) = _StoragePath;
}
