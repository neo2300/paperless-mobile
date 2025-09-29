import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for DocumentsApi
void main() {
  final instance = PaperlessNgxApiV9().getDocumentsApi();

  group(DocumentsApi, () {
    // Perform a bulk edit operation on a list of documents
    //
    //Future<BulkEditDocumentsResult> bulkEdit(BulkEditRequest bulkEditRequest) async
    test('test bulkEdit', () async {
      // TODO
    });

    // View share links for the document
    //
    //Future<List<DocumentShareLinks200ResponseInner>> documentShareLinks(String id) async
    test('test documentShareLinks', () async {
      // TODO
    });

    //Future<BulkDownload> documentsBulkDownloadCreate(BulkDownloadRequest bulkDownloadRequest) async
    test('test documentsBulkDownloadCreate', () async {
      // TODO
    });

    // Pass a user object to serializer
    //
    //Future documentsDestroy(int id) async
    test('test documentsDestroy', () async {
      // TODO
    });

    // Download the document
    //
    //Future<Uint8List> documentsDownloadRetrieve(int id, { bool original }) async
    test('test documentsDownloadRetrieve', () async {
      // TODO
    });

    // Email the document to one or more recipients as an attachment.
    //
    //Future<EmailResponse> documentsEmailCreate(int id, EmailRequestRequest emailRequestRequest) async
    test('test documentsEmailCreate', () async {
      // TODO
    });

    // View the document history
    //
    //Future<PaginatedLogEntryList> documentsHistoryList(int id, { int page, int pageSize }) async
    test('test documentsHistoryList', () async {
      // TODO
    });

    // Pass a user object to serializer
    //
    //Future<PaginatedDocumentList> documentsList({ DateTime addedDateGt, DateTime addedDateGte, DateTime addedDateLt, DateTime addedDateLte, num addedDay, DateTime addedGt, DateTime addedGte, DateTime addedLt, DateTime addedLte, num addedMonth, num addedYear, int archiveSerialNumber, int archiveSerialNumberGt, int archiveSerialNumberGte, bool archiveSerialNumberIsnull, int archiveSerialNumberLt, int archiveSerialNumberLte, String checksumIcontains, String checksumIendswith, String checksumIexact, String checksumIstartswith, String contentIcontains, String contentIendswith, String contentIexact, String contentIstartswith, int correspondentId, List<int> correspondentIdIn, int correspondentIdNone, bool correspondentIsnull, String correspondentNameIcontains, String correspondentNameIendswith, String correspondentNameIexact, String correspondentNameIstartswith, DateTime createdDateGt, DateTime createdDateGte, DateTime createdDateLt, DateTime createdDateLte, num createdDay, DateTime createdGt, DateTime createdGte, DateTime createdLt, DateTime createdLte, num createdMonth, num createdYear, String customFieldQuery, String customFieldsIcontains, int customFieldsIdAll, int customFieldsIdIn, int customFieldsIdNone, int documentTypeId, List<int> documentTypeIdIn, int documentTypeIdNone, bool documentTypeIsnull, String documentTypeNameIcontains, String documentTypeNameIendswith, String documentTypeNameIexact, String documentTypeNameIstartswith, List<String> fields, bool fullPerms, bool hasCustomFields, int id, List<int> idIn, bool isInInbox, bool isTagged, String mimeType, DateTime modifiedDateGt, DateTime modifiedDateGte, DateTime modifiedDateLt, DateTime modifiedDateLte, num modifiedDay, DateTime modifiedGt, DateTime modifiedGte, DateTime modifiedLt, DateTime modifiedLte, num modifiedMonth, num modifiedYear, String ordering, String originalFilenameIcontains, String originalFilenameIendswith, String originalFilenameIexact, String originalFilenameIstartswith, int ownerId, List<int> ownerIdIn, int ownerIdNone, bool ownerIsnull, int page, int pageSize, String search, bool sharedById, int storagePathId, List<int> storagePathIdIn, int storagePathIdNone, bool storagePathIsnull, String storagePathNameIcontains, String storagePathNameIendswith, String storagePathNameIexact, String storagePathNameIstartswith, int tagsId, int tagsIdAll, int tagsIdIn, int tagsIdNone, String tagsNameIcontains, String tagsNameIendswith, String tagsNameIexact, String tagsNameIstartswith, String titleIcontains, String titleIendswith, String titleIexact, String titleIstartswith, String titleContent }) async
    test('test documentsList', () async {
      // TODO
    });

    // View the document metadata
    //
    //Future<Metadata> documentsMetadataRetrieve(int id) async
    test('test documentsMetadataRetrieve', () async {
      // TODO
    });

    // Get the next available Archive Serial Number (ASN) for a new document
    //
    //Future<int> documentsNextAsnRetrieve() async
    test('test documentsNextAsnRetrieve', () async {
      // TODO
    });

    // View, add, or delete notes for the document
    //
    //Future<PaginatedNotesList> documentsNotesCreate(int id, NoteCreateRequestRequest noteCreateRequestRequest, { int id2, int page, int pageSize }) async
    test('test documentsNotesCreate', () async {
      // TODO
    });

    // View, add, or delete notes for the document
    //
    //Future<PaginatedNotesList> documentsNotesDestroy(int id, { int id2, int page, int pageSize }) async
    test('test documentsNotesDestroy', () async {
      // TODO
    });

    // View, add, or delete notes for the document
    //
    //Future<PaginatedNotesList> documentsNotesList(int id, { int id2, int page, int pageSize }) async
    test('test documentsNotesList', () async {
      // TODO
    });

    // Pass a user object to serializer
    //
    //Future<Document> documentsPartialUpdate(int id, { PatchedDocumentRequest patchedDocumentRequest }) async
    test('test documentsPartialUpdate', () async {
      // TODO
    });

    // Upload a document via the API
    //
    //Future<String> documentsPostDocumentCreate(MultipartFile document, { DateTime created, String title, int correspondent, int documentType, int storagePath, List<int> tags, int archiveSerialNumber, List<int> customFields, bool fromWebui }) async
    test('test documentsPostDocumentCreate', () async {
      // TODO
    });

    // View the document preview
    //
    //Future<Uint8List> documentsPreviewRetrieve(int id) async
    test('test documentsPreviewRetrieve', () async {
      // TODO
    });

    // Retrieve a single document
    //
    //Future<Document> documentsRetrieve(int id, { List<String> fields, bool fullPerms }) async
    test('test documentsRetrieve', () async {
      // TODO
    });

    // Get selection data for the selected documents
    //
    //Future<SelectionData> documentsSelectionDataCreate(List<int> documents) async
    test('test documentsSelectionDataCreate', () async {
      // TODO
    });

    // View suggestions for the document
    //
    //Future<Suggestions> documentsSuggestionsRetrieve(int id) async
    test('test documentsSuggestionsRetrieve', () async {
      // TODO
    });

    // View the document thumbnail
    //
    //Future<Uint8List> documentsThumbRetrieve(int id) async
    test('test documentsThumbRetrieve', () async {
      // TODO
    });

    // Pass a user object to serializer
    //
    //Future<Document> documentsUpdate(int id, DocumentRequest documentRequest) async
    test('test documentsUpdate', () async {
      // TODO
    });
  });
}
