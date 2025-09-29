part of 'document_details_cubit.dart';

@freezed
class DocumentDetailsData with _$DocumentDetailsData {
  const factory DocumentDetailsData({
    required Document document,
    required Metadata metaData,
    required Suggestions fieldSuggestions,
    required int nextAsn,
    required List<Correspondent> correspondents,
    required List<DocumentType> documentTypes,
    required List<Tag> tags,
    required List<StoragePath> storagePaths,
  }) = _DocumentDetailsData;
}

typedef DocumentDetailsState = BaseState<DocumentDetailsData>;
