# paperless_ngx_api_v9.api.DocumentsApi

## Load the API package
```dart
import 'package:paperless_ngx_api_v9/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bulkEdit**](DocumentsApi.md#bulkedit) | **POST** /api/documents/bulk_edit/ | 
[**documentShareLinks**](DocumentsApi.md#documentsharelinks) | **GET** /api/documents/{id}/share_links/ | 
[**documentsBulkDownloadCreate**](DocumentsApi.md#documentsbulkdownloadcreate) | **POST** /api/documents/bulk_download/ | 
[**documentsDestroy**](DocumentsApi.md#documentsdestroy) | **DELETE** /api/documents/{id}/ | 
[**documentsDownloadRetrieve**](DocumentsApi.md#documentsdownloadretrieve) | **GET** /api/documents/{id}/download/ | 
[**documentsEmailCreate**](DocumentsApi.md#documentsemailcreate) | **POST** /api/documents/{id}/email/ | 
[**documentsHistoryList**](DocumentsApi.md#documentshistorylist) | **GET** /api/documents/{id}/history/ | 
[**documentsList**](DocumentsApi.md#documentslist) | **GET** /api/documents/ | 
[**documentsMetadataRetrieve**](DocumentsApi.md#documentsmetadataretrieve) | **GET** /api/documents/{id}/metadata/ | 
[**documentsNextAsnRetrieve**](DocumentsApi.md#documentsnextasnretrieve) | **GET** /api/documents/next_asn/ | 
[**documentsNotesCreate**](DocumentsApi.md#documentsnotescreate) | **POST** /api/documents/{id}/notes/ | 
[**documentsNotesDestroy**](DocumentsApi.md#documentsnotesdestroy) | **DELETE** /api/documents/{id}/notes/ | 
[**documentsNotesList**](DocumentsApi.md#documentsnoteslist) | **GET** /api/documents/{id}/notes/ | 
[**documentsPartialUpdate**](DocumentsApi.md#documentspartialupdate) | **PATCH** /api/documents/{id}/ | 
[**documentsPostDocumentCreate**](DocumentsApi.md#documentspostdocumentcreate) | **POST** /api/documents/post_document/ | 
[**documentsPreviewRetrieve**](DocumentsApi.md#documentspreviewretrieve) | **GET** /api/documents/{id}/preview/ | 
[**documentsRetrieve**](DocumentsApi.md#documentsretrieve) | **GET** /api/documents/{id}/ | 
[**documentsSelectionDataCreate**](DocumentsApi.md#documentsselectiondatacreate) | **POST** /api/documents/selection_data/ | 
[**documentsSuggestionsRetrieve**](DocumentsApi.md#documentssuggestionsretrieve) | **GET** /api/documents/{id}/suggestions/ | 
[**documentsThumbRetrieve**](DocumentsApi.md#documentsthumbretrieve) | **GET** /api/documents/{id}/thumb/ | 
[**documentsUpdate**](DocumentsApi.md#documentsupdate) | **PUT** /api/documents/{id}/ | 


# **bulkEdit**
> BulkEditDocumentsResult bulkEdit(bulkEditRequest)



Perform a bulk edit operation on a list of documents

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final BulkEditRequest bulkEditRequest = ; // BulkEditRequest | 

try {
    final response = api.bulkEdit(bulkEditRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->bulkEdit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bulkEditRequest** | [**BulkEditRequest**](BulkEditRequest.md)|  | 

### Return type

[**BulkEditDocumentsResult**](BulkEditDocumentsResult.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentShareLinks**
> List<DocumentShareLinks200ResponseInner> documentShareLinks(id)



View share links for the document

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final String id = id_example; // String | 

try {
    final response = api.documentShareLinks(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentShareLinks: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**List&lt;DocumentShareLinks200ResponseInner&gt;**](DocumentShareLinks200ResponseInner.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsBulkDownloadCreate**
> BulkDownload documentsBulkDownloadCreate(bulkDownloadRequest)



### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final BulkDownloadRequest bulkDownloadRequest = ; // BulkDownloadRequest | 

try {
    final response = api.documentsBulkDownloadCreate(bulkDownloadRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsBulkDownloadCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bulkDownloadRequest** | [**BulkDownloadRequest**](BulkDownloadRequest.md)|  | 

### Return type

[**BulkDownload**](BulkDownload.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsDestroy**
> documentsDestroy(id)



Pass a user object to serializer

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.

try {
    api.documentsDestroy(id);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsDestroy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 

### Return type

void (empty response body)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsDownloadRetrieve**
> Uint8List documentsDownloadRetrieve(id, original)



Download the document

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.
final bool original = true; // bool | 

try {
    final response = api.documentsDownloadRetrieve(id, original);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsDownloadRetrieve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 
 **original** | **bool**|  | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsEmailCreate**
> EmailResponse documentsEmailCreate(id, emailRequestRequest)



Email the document to one or more recipients as an attachment.

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.
final EmailRequestRequest emailRequestRequest = ; // EmailRequestRequest | 

try {
    final response = api.documentsEmailCreate(id, emailRequestRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsEmailCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 
 **emailRequestRequest** | [**EmailRequestRequest**](EmailRequestRequest.md)|  | 

### Return type

[**EmailResponse**](EmailResponse.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsHistoryList**
> PaginatedLogEntryList documentsHistoryList(id, page, pageSize)



View the document history

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.
final int page = 56; // int | A page number within the paginated result set.
final int pageSize = 56; // int | Number of results to return per page.

try {
    final response = api.documentsHistoryList(id, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsHistoryList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 
 **page** | **int**| A page number within the paginated result set. | [optional] 
 **pageSize** | **int**| Number of results to return per page. | [optional] 

### Return type

[**PaginatedLogEntryList**](PaginatedLogEntryList.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsList**
> PaginatedDocumentList documentsList(addedDateGt, addedDateGte, addedDateLt, addedDateLte, addedDay, addedGt, addedGte, addedLt, addedLte, addedMonth, addedYear, archiveSerialNumber, archiveSerialNumberGt, archiveSerialNumberGte, archiveSerialNumberIsnull, archiveSerialNumberLt, archiveSerialNumberLte, checksumIcontains, checksumIendswith, checksumIexact, checksumIstartswith, contentIcontains, contentIendswith, contentIexact, contentIstartswith, correspondentId, correspondentIdIn, correspondentIdNone, correspondentIsnull, correspondentNameIcontains, correspondentNameIendswith, correspondentNameIexact, correspondentNameIstartswith, createdDateGt, createdDateGte, createdDateLt, createdDateLte, createdDay, createdGt, createdGte, createdLt, createdLte, createdMonth, createdYear, customFieldQuery, customFieldsIcontains, customFieldsIdAll, customFieldsIdIn, customFieldsIdNone, documentTypeId, documentTypeIdIn, documentTypeIdNone, documentTypeIsnull, documentTypeNameIcontains, documentTypeNameIendswith, documentTypeNameIexact, documentTypeNameIstartswith, fields, fullPerms, hasCustomFields, id, idIn, isInInbox, isTagged, mimeType, modifiedDateGt, modifiedDateGte, modifiedDateLt, modifiedDateLte, modifiedDay, modifiedGt, modifiedGte, modifiedLt, modifiedLte, modifiedMonth, modifiedYear, ordering, originalFilenameIcontains, originalFilenameIendswith, originalFilenameIexact, originalFilenameIstartswith, ownerId, ownerIdIn, ownerIdNone, ownerIsnull, page, pageSize, search, sharedById, storagePathId, storagePathIdIn, storagePathIdNone, storagePathIsnull, storagePathNameIcontains, storagePathNameIendswith, storagePathNameIexact, storagePathNameIstartswith, tagsId, tagsIdAll, tagsIdIn, tagsIdNone, tagsNameIcontains, tagsNameIendswith, tagsNameIexact, tagsNameIstartswith, titleIcontains, titleIendswith, titleIexact, titleIstartswith, titleContent)



Pass a user object to serializer

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final DateTime addedDateGt = 2013-10-20; // DateTime | 
final DateTime addedDateGte = 2013-10-20; // DateTime | 
final DateTime addedDateLt = 2013-10-20; // DateTime | 
final DateTime addedDateLte = 2013-10-20; // DateTime | 
final num addedDay = 8.14; // num | 
final DateTime addedGt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime addedGte = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime addedLt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime addedLte = 2013-10-20T19:20:30+01:00; // DateTime | 
final num addedMonth = 8.14; // num | 
final num addedYear = 8.14; // num | 
final int archiveSerialNumber = 56; // int | 
final int archiveSerialNumberGt = 56; // int | 
final int archiveSerialNumberGte = 56; // int | 
final bool archiveSerialNumberIsnull = true; // bool | 
final int archiveSerialNumberLt = 56; // int | 
final int archiveSerialNumberLte = 56; // int | 
final String checksumIcontains = checksumIcontains_example; // String | 
final String checksumIendswith = checksumIendswith_example; // String | 
final String checksumIexact = checksumIexact_example; // String | 
final String checksumIstartswith = checksumIstartswith_example; // String | 
final String contentIcontains = contentIcontains_example; // String | 
final String contentIendswith = contentIendswith_example; // String | 
final String contentIexact = contentIexact_example; // String | 
final String contentIstartswith = contentIstartswith_example; // String | 
final int correspondentId = 56; // int | 
final List<int> correspondentIdIn = ; // List<int> | Multiple values may be separated by commas.
final int correspondentIdNone = 56; // int | 
final bool correspondentIsnull = true; // bool | 
final String correspondentNameIcontains = correspondentNameIcontains_example; // String | 
final String correspondentNameIendswith = correspondentNameIendswith_example; // String | 
final String correspondentNameIexact = correspondentNameIexact_example; // String | 
final String correspondentNameIstartswith = correspondentNameIstartswith_example; // String | 
final DateTime createdDateGt = 2013-10-20; // DateTime | 
final DateTime createdDateGte = 2013-10-20; // DateTime | 
final DateTime createdDateLt = 2013-10-20; // DateTime | 
final DateTime createdDateLte = 2013-10-20; // DateTime | 
final num createdDay = 8.14; // num | 
final DateTime createdGt = 2013-10-20; // DateTime | 
final DateTime createdGte = 2013-10-20; // DateTime | 
final DateTime createdLt = 2013-10-20; // DateTime | 
final DateTime createdLte = 2013-10-20; // DateTime | 
final num createdMonth = 8.14; // num | 
final num createdYear = 8.14; // num | 
final String customFieldQuery = customFieldQuery_example; // String | 
final String customFieldsIcontains = customFieldsIcontains_example; // String | 
final int customFieldsIdAll = 56; // int | 
final int customFieldsIdIn = 56; // int | 
final int customFieldsIdNone = 56; // int | 
final int documentTypeId = 56; // int | 
final List<int> documentTypeIdIn = ; // List<int> | Multiple values may be separated by commas.
final int documentTypeIdNone = 56; // int | 
final bool documentTypeIsnull = true; // bool | 
final String documentTypeNameIcontains = documentTypeNameIcontains_example; // String | 
final String documentTypeNameIendswith = documentTypeNameIendswith_example; // String | 
final String documentTypeNameIexact = documentTypeNameIexact_example; // String | 
final String documentTypeNameIstartswith = documentTypeNameIstartswith_example; // String | 
final List<String> fields = ; // List<String> | 
final bool fullPerms = true; // bool | 
final bool hasCustomFields = true; // bool | Has custom field
final int id = 56; // int | 
final List<int> idIn = ; // List<int> | Multiple values may be separated by commas.
final bool isInInbox = true; // bool | 
final bool isTagged = true; // bool | Is tagged
final String mimeType = mimeType_example; // String | 
final DateTime modifiedDateGt = 2013-10-20; // DateTime | 
final DateTime modifiedDateGte = 2013-10-20; // DateTime | 
final DateTime modifiedDateLt = 2013-10-20; // DateTime | 
final DateTime modifiedDateLte = 2013-10-20; // DateTime | 
final num modifiedDay = 8.14; // num | 
final DateTime modifiedGt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime modifiedGte = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime modifiedLt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime modifiedLte = 2013-10-20T19:20:30+01:00; // DateTime | 
final num modifiedMonth = 8.14; // num | 
final num modifiedYear = 8.14; // num | 
final String ordering = ordering_example; // String | Which field to use when ordering the results.
final String originalFilenameIcontains = originalFilenameIcontains_example; // String | 
final String originalFilenameIendswith = originalFilenameIendswith_example; // String | 
final String originalFilenameIexact = originalFilenameIexact_example; // String | 
final String originalFilenameIstartswith = originalFilenameIstartswith_example; // String | 
final int ownerId = 56; // int | 
final List<int> ownerIdIn = ; // List<int> | Multiple values may be separated by commas.
final int ownerIdNone = 56; // int | 
final bool ownerIsnull = true; // bool | 
final int page = 56; // int | A page number within the paginated result set.
final int pageSize = 56; // int | Number of results to return per page.
final String search = search_example; // String | A search term.
final bool sharedById = true; // bool | 
final int storagePathId = 56; // int | 
final List<int> storagePathIdIn = ; // List<int> | Multiple values may be separated by commas.
final int storagePathIdNone = 56; // int | 
final bool storagePathIsnull = true; // bool | 
final String storagePathNameIcontains = storagePathNameIcontains_example; // String | 
final String storagePathNameIendswith = storagePathNameIendswith_example; // String | 
final String storagePathNameIexact = storagePathNameIexact_example; // String | 
final String storagePathNameIstartswith = storagePathNameIstartswith_example; // String | 
final int tagsId = 56; // int | 
final int tagsIdAll = 56; // int | 
final int tagsIdIn = 56; // int | 
final int tagsIdNone = 56; // int | 
final String tagsNameIcontains = tagsNameIcontains_example; // String | 
final String tagsNameIendswith = tagsNameIendswith_example; // String | 
final String tagsNameIexact = tagsNameIexact_example; // String | 
final String tagsNameIstartswith = tagsNameIstartswith_example; // String | 
final String titleIcontains = titleIcontains_example; // String | 
final String titleIendswith = titleIendswith_example; // String | 
final String titleIexact = titleIexact_example; // String | 
final String titleIstartswith = titleIstartswith_example; // String | 
final String titleContent = titleContent_example; // String | 

try {
    final response = api.documentsList(addedDateGt, addedDateGte, addedDateLt, addedDateLte, addedDay, addedGt, addedGte, addedLt, addedLte, addedMonth, addedYear, archiveSerialNumber, archiveSerialNumberGt, archiveSerialNumberGte, archiveSerialNumberIsnull, archiveSerialNumberLt, archiveSerialNumberLte, checksumIcontains, checksumIendswith, checksumIexact, checksumIstartswith, contentIcontains, contentIendswith, contentIexact, contentIstartswith, correspondentId, correspondentIdIn, correspondentIdNone, correspondentIsnull, correspondentNameIcontains, correspondentNameIendswith, correspondentNameIexact, correspondentNameIstartswith, createdDateGt, createdDateGte, createdDateLt, createdDateLte, createdDay, createdGt, createdGte, createdLt, createdLte, createdMonth, createdYear, customFieldQuery, customFieldsIcontains, customFieldsIdAll, customFieldsIdIn, customFieldsIdNone, documentTypeId, documentTypeIdIn, documentTypeIdNone, documentTypeIsnull, documentTypeNameIcontains, documentTypeNameIendswith, documentTypeNameIexact, documentTypeNameIstartswith, fields, fullPerms, hasCustomFields, id, idIn, isInInbox, isTagged, mimeType, modifiedDateGt, modifiedDateGte, modifiedDateLt, modifiedDateLte, modifiedDay, modifiedGt, modifiedGte, modifiedLt, modifiedLte, modifiedMonth, modifiedYear, ordering, originalFilenameIcontains, originalFilenameIendswith, originalFilenameIexact, originalFilenameIstartswith, ownerId, ownerIdIn, ownerIdNone, ownerIsnull, page, pageSize, search, sharedById, storagePathId, storagePathIdIn, storagePathIdNone, storagePathIsnull, storagePathNameIcontains, storagePathNameIendswith, storagePathNameIexact, storagePathNameIstartswith, tagsId, tagsIdAll, tagsIdIn, tagsIdNone, tagsNameIcontains, tagsNameIendswith, tagsNameIexact, tagsNameIstartswith, titleIcontains, titleIendswith, titleIexact, titleIstartswith, titleContent);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addedDateGt** | **DateTime**|  | [optional] 
 **addedDateGte** | **DateTime**|  | [optional] 
 **addedDateLt** | **DateTime**|  | [optional] 
 **addedDateLte** | **DateTime**|  | [optional] 
 **addedDay** | **num**|  | [optional] 
 **addedGt** | **DateTime**|  | [optional] 
 **addedGte** | **DateTime**|  | [optional] 
 **addedLt** | **DateTime**|  | [optional] 
 **addedLte** | **DateTime**|  | [optional] 
 **addedMonth** | **num**|  | [optional] 
 **addedYear** | **num**|  | [optional] 
 **archiveSerialNumber** | **int**|  | [optional] 
 **archiveSerialNumberGt** | **int**|  | [optional] 
 **archiveSerialNumberGte** | **int**|  | [optional] 
 **archiveSerialNumberIsnull** | **bool**|  | [optional] 
 **archiveSerialNumberLt** | **int**|  | [optional] 
 **archiveSerialNumberLte** | **int**|  | [optional] 
 **checksumIcontains** | **String**|  | [optional] 
 **checksumIendswith** | **String**|  | [optional] 
 **checksumIexact** | **String**|  | [optional] 
 **checksumIstartswith** | **String**|  | [optional] 
 **contentIcontains** | **String**|  | [optional] 
 **contentIendswith** | **String**|  | [optional] 
 **contentIexact** | **String**|  | [optional] 
 **contentIstartswith** | **String**|  | [optional] 
 **correspondentId** | **int**|  | [optional] 
 **correspondentIdIn** | [**List&lt;int&gt;**](int.md)| Multiple values may be separated by commas. | [optional] 
 **correspondentIdNone** | **int**|  | [optional] 
 **correspondentIsnull** | **bool**|  | [optional] 
 **correspondentNameIcontains** | **String**|  | [optional] 
 **correspondentNameIendswith** | **String**|  | [optional] 
 **correspondentNameIexact** | **String**|  | [optional] 
 **correspondentNameIstartswith** | **String**|  | [optional] 
 **createdDateGt** | **DateTime**|  | [optional] 
 **createdDateGte** | **DateTime**|  | [optional] 
 **createdDateLt** | **DateTime**|  | [optional] 
 **createdDateLte** | **DateTime**|  | [optional] 
 **createdDay** | **num**|  | [optional] 
 **createdGt** | **DateTime**|  | [optional] 
 **createdGte** | **DateTime**|  | [optional] 
 **createdLt** | **DateTime**|  | [optional] 
 **createdLte** | **DateTime**|  | [optional] 
 **createdMonth** | **num**|  | [optional] 
 **createdYear** | **num**|  | [optional] 
 **customFieldQuery** | **String**|  | [optional] 
 **customFieldsIcontains** | **String**|  | [optional] 
 **customFieldsIdAll** | **int**|  | [optional] 
 **customFieldsIdIn** | **int**|  | [optional] 
 **customFieldsIdNone** | **int**|  | [optional] 
 **documentTypeId** | **int**|  | [optional] 
 **documentTypeIdIn** | [**List&lt;int&gt;**](int.md)| Multiple values may be separated by commas. | [optional] 
 **documentTypeIdNone** | **int**|  | [optional] 
 **documentTypeIsnull** | **bool**|  | [optional] 
 **documentTypeNameIcontains** | **String**|  | [optional] 
 **documentTypeNameIendswith** | **String**|  | [optional] 
 **documentTypeNameIexact** | **String**|  | [optional] 
 **documentTypeNameIstartswith** | **String**|  | [optional] 
 **fields** | [**List&lt;String&gt;**](String.md)|  | [optional] 
 **fullPerms** | **bool**|  | [optional] 
 **hasCustomFields** | **bool**| Has custom field | [optional] 
 **id** | **int**|  | [optional] 
 **idIn** | [**List&lt;int&gt;**](int.md)| Multiple values may be separated by commas. | [optional] 
 **isInInbox** | **bool**|  | [optional] 
 **isTagged** | **bool**| Is tagged | [optional] 
 **mimeType** | **String**|  | [optional] 
 **modifiedDateGt** | **DateTime**|  | [optional] 
 **modifiedDateGte** | **DateTime**|  | [optional] 
 **modifiedDateLt** | **DateTime**|  | [optional] 
 **modifiedDateLte** | **DateTime**|  | [optional] 
 **modifiedDay** | **num**|  | [optional] 
 **modifiedGt** | **DateTime**|  | [optional] 
 **modifiedGte** | **DateTime**|  | [optional] 
 **modifiedLt** | **DateTime**|  | [optional] 
 **modifiedLte** | **DateTime**|  | [optional] 
 **modifiedMonth** | **num**|  | [optional] 
 **modifiedYear** | **num**|  | [optional] 
 **ordering** | **String**| Which field to use when ordering the results. | [optional] 
 **originalFilenameIcontains** | **String**|  | [optional] 
 **originalFilenameIendswith** | **String**|  | [optional] 
 **originalFilenameIexact** | **String**|  | [optional] 
 **originalFilenameIstartswith** | **String**|  | [optional] 
 **ownerId** | **int**|  | [optional] 
 **ownerIdIn** | [**List&lt;int&gt;**](int.md)| Multiple values may be separated by commas. | [optional] 
 **ownerIdNone** | **int**|  | [optional] 
 **ownerIsnull** | **bool**|  | [optional] 
 **page** | **int**| A page number within the paginated result set. | [optional] 
 **pageSize** | **int**| Number of results to return per page. | [optional] 
 **search** | **String**| A search term. | [optional] 
 **sharedById** | **bool**|  | [optional] 
 **storagePathId** | **int**|  | [optional] 
 **storagePathIdIn** | [**List&lt;int&gt;**](int.md)| Multiple values may be separated by commas. | [optional] 
 **storagePathIdNone** | **int**|  | [optional] 
 **storagePathIsnull** | **bool**|  | [optional] 
 **storagePathNameIcontains** | **String**|  | [optional] 
 **storagePathNameIendswith** | **String**|  | [optional] 
 **storagePathNameIexact** | **String**|  | [optional] 
 **storagePathNameIstartswith** | **String**|  | [optional] 
 **tagsId** | **int**|  | [optional] 
 **tagsIdAll** | **int**|  | [optional] 
 **tagsIdIn** | **int**|  | [optional] 
 **tagsIdNone** | **int**|  | [optional] 
 **tagsNameIcontains** | **String**|  | [optional] 
 **tagsNameIendswith** | **String**|  | [optional] 
 **tagsNameIexact** | **String**|  | [optional] 
 **tagsNameIstartswith** | **String**|  | [optional] 
 **titleIcontains** | **String**|  | [optional] 
 **titleIendswith** | **String**|  | [optional] 
 **titleIexact** | **String**|  | [optional] 
 **titleIstartswith** | **String**|  | [optional] 
 **titleContent** | **String**|  | [optional] 

### Return type

[**PaginatedDocumentList**](PaginatedDocumentList.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsMetadataRetrieve**
> Metadata documentsMetadataRetrieve(id)



View the document metadata

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.

try {
    final response = api.documentsMetadataRetrieve(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsMetadataRetrieve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 

### Return type

[**Metadata**](Metadata.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsNextAsnRetrieve**
> int documentsNextAsnRetrieve()



Get the next available Archive Serial Number (ASN) for a new document

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();

try {
    final response = api.documentsNextAsnRetrieve();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsNextAsnRetrieve: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**int**

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsNotesCreate**
> PaginatedNotesList documentsNotesCreate(id, noteCreateRequestRequest, id2, page, pageSize)



View, add, or delete notes for the document

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.
final NoteCreateRequestRequest noteCreateRequestRequest = ; // NoteCreateRequestRequest | 
final int id2 = 56; // int | Note ID to delete (used only for DELETE requests)
final int page = 56; // int | A page number within the paginated result set.
final int pageSize = 56; // int | Number of results to return per page.

try {
    final response = api.documentsNotesCreate(id, noteCreateRequestRequest, id2, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsNotesCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 
 **noteCreateRequestRequest** | [**NoteCreateRequestRequest**](NoteCreateRequestRequest.md)|  | 
 **id2** | **int**| Note ID to delete (used only for DELETE requests) | [optional] 
 **page** | **int**| A page number within the paginated result set. | [optional] 
 **pageSize** | **int**| Number of results to return per page. | [optional] 

### Return type

[**PaginatedNotesList**](PaginatedNotesList.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsNotesDestroy**
> PaginatedNotesList documentsNotesDestroy(id, id2, page, pageSize)



View, add, or delete notes for the document

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.
final int id2 = 56; // int | Note ID to delete (used only for DELETE requests)
final int page = 56; // int | A page number within the paginated result set.
final int pageSize = 56; // int | Number of results to return per page.

try {
    final response = api.documentsNotesDestroy(id, id2, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsNotesDestroy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 
 **id2** | **int**| Note ID to delete (used only for DELETE requests) | [optional] 
 **page** | **int**| A page number within the paginated result set. | [optional] 
 **pageSize** | **int**| Number of results to return per page. | [optional] 

### Return type

[**PaginatedNotesList**](PaginatedNotesList.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsNotesList**
> PaginatedNotesList documentsNotesList(id, id2, page, pageSize)



View, add, or delete notes for the document

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.
final int id2 = 56; // int | Note ID to delete (used only for DELETE requests)
final int page = 56; // int | A page number within the paginated result set.
final int pageSize = 56; // int | Number of results to return per page.

try {
    final response = api.documentsNotesList(id, id2, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsNotesList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 
 **id2** | **int**| Note ID to delete (used only for DELETE requests) | [optional] 
 **page** | **int**| A page number within the paginated result set. | [optional] 
 **pageSize** | **int**| Number of results to return per page. | [optional] 

### Return type

[**PaginatedNotesList**](PaginatedNotesList.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsPartialUpdate**
> Document documentsPartialUpdate(id, patchedDocumentRequest)



Pass a user object to serializer

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.
final PatchedDocumentRequest patchedDocumentRequest = ; // PatchedDocumentRequest | 

try {
    final response = api.documentsPartialUpdate(id, patchedDocumentRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsPartialUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 
 **patchedDocumentRequest** | [**PatchedDocumentRequest**](PatchedDocumentRequest.md)|  | [optional] 

### Return type

[**Document**](Document.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsPostDocumentCreate**
> String documentsPostDocumentCreate(document, created, title, correspondent, documentType, storagePath, tags, archiveSerialNumber, customFields, fromWebui)



Upload a document via the API

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final MultipartFile document = BINARY_DATA_HERE; // MultipartFile | 
final DateTime created = 2013-10-20T19:20:30+01:00; // DateTime | 
final String title = title_example; // String | 
final int correspondent = 56; // int | 
final int documentType = 56; // int | 
final int storagePath = 56; // int | 
final List<int> tags = ; // List<int> | 
final int archiveSerialNumber = 789; // int | 
final List<int> customFields = ; // List<int> | 
final bool fromWebui = true; // bool | 

try {
    final response = api.documentsPostDocumentCreate(document, created, title, correspondent, documentType, storagePath, tags, archiveSerialNumber, customFields, fromWebui);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsPostDocumentCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **document** | **MultipartFile**|  | 
 **created** | **DateTime**|  | [optional] 
 **title** | **String**|  | [optional] 
 **correspondent** | **int**|  | [optional] 
 **documentType** | **int**|  | [optional] 
 **storagePath** | **int**|  | [optional] 
 **tags** | [**List&lt;int&gt;**](int.md)|  | [optional] 
 **archiveSerialNumber** | **int**|  | [optional] 
 **customFields** | [**List&lt;int&gt;**](int.md)|  | [optional] 
 **fromWebui** | **bool**|  | [optional] 

### Return type

**String**

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsPreviewRetrieve**
> Uint8List documentsPreviewRetrieve(id)



View the document preview

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.

try {
    final response = api.documentsPreviewRetrieve(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsPreviewRetrieve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsRetrieve**
> Document documentsRetrieve(id, fields, fullPerms)



Retrieve a single document

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.
final List<String> fields = ; // List<String> | 
final bool fullPerms = true; // bool | 

try {
    final response = api.documentsRetrieve(id, fields, fullPerms);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsRetrieve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 
 **fields** | [**List&lt;String&gt;**](String.md)|  | [optional] 
 **fullPerms** | **bool**|  | [optional] 

### Return type

[**Document**](Document.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsSelectionDataCreate**
> SelectionData documentsSelectionDataCreate(documents)



Get selection data for the selected documents

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final List<int> documents = ; // List<int> | 

try {
    final response = api.documentsSelectionDataCreate(documents);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsSelectionDataCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **documents** | [**List&lt;int&gt;**](int.md)|  | 

### Return type

[**SelectionData**](SelectionData.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: multipart/form-data, application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsSuggestionsRetrieve**
> Suggestions documentsSuggestionsRetrieve(id)



View suggestions for the document

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.

try {
    final response = api.documentsSuggestionsRetrieve(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsSuggestionsRetrieve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 

### Return type

[**Suggestions**](Suggestions.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsThumbRetrieve**
> Uint8List documentsThumbRetrieve(id)



View the document thumbnail

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.

try {
    final response = api.documentsThumbRetrieve(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsThumbRetrieve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **documentsUpdate**
> Document documentsUpdate(id, documentRequest)



Pass a user object to serializer

### Example
```dart
import 'package:paperless_ngx_api_v9/api.dart';
// TODO Configure API key authorization: tokenAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('tokenAuth').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: cookieAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('cookieAuth').apiKeyPrefix = 'Bearer';
// TODO Configure HTTP basic authorization: PaperelessBasicAuthentication
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('PaperelessBasicAuthentication').password = 'YOUR_PASSWORD';

final api = PaperlessNgxApiV9().getDocumentsApi();
final int id = 56; // int | A unique integer value identifying this document.
final DocumentRequest documentRequest = ; // DocumentRequest | 

try {
    final response = api.documentsUpdate(id, documentRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DocumentsApi->documentsUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this document. | 
 **documentRequest** | [**DocumentRequest**](DocumentRequest.md)|  | 

### Return type

[**Document**](Document.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

