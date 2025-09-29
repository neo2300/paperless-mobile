# paperless_ngx_api_v9.api.CorrespondentsApi

## Load the API package
```dart
import 'package:paperless_ngx_api_v9/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**correspondentsCreate**](CorrespondentsApi.md#correspondentscreate) | **POST** /api/correspondents/ | 
[**correspondentsDestroy**](CorrespondentsApi.md#correspondentsdestroy) | **DELETE** /api/correspondents/{id}/ | 
[**correspondentsList**](CorrespondentsApi.md#correspondentslist) | **GET** /api/correspondents/ | 
[**correspondentsPartialUpdate**](CorrespondentsApi.md#correspondentspartialupdate) | **PATCH** /api/correspondents/{id}/ | 
[**correspondentsRetrieve**](CorrespondentsApi.md#correspondentsretrieve) | **GET** /api/correspondents/{id}/ | 
[**correspondentsUpdate**](CorrespondentsApi.md#correspondentsupdate) | **PUT** /api/correspondents/{id}/ | 


# **correspondentsCreate**
> Correspondent correspondentsCreate(correspondentRequest)



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

final api = PaperlessNgxApiV9().getCorrespondentsApi();
final CorrespondentRequest correspondentRequest = ; // CorrespondentRequest | 

try {
    final response = api.correspondentsCreate(correspondentRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CorrespondentsApi->correspondentsCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **correspondentRequest** | [**CorrespondentRequest**](CorrespondentRequest.md)|  | 

### Return type

[**Correspondent**](Correspondent.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **correspondentsDestroy**
> correspondentsDestroy(id)



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

final api = PaperlessNgxApiV9().getCorrespondentsApi();
final int id = 56; // int | A unique integer value identifying this correspondent.

try {
    api.correspondentsDestroy(id);
} catch on DioException (e) {
    print('Exception when calling CorrespondentsApi->correspondentsDestroy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this correspondent. | 

### Return type

void (empty response body)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **correspondentsList**
> PaginatedCorrespondentList correspondentsList(fullPerms, id, idIn, nameIcontains, nameIendswith, nameIexact, nameIstartswith, ordering, page, pageSize)



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

final api = PaperlessNgxApiV9().getCorrespondentsApi();
final bool fullPerms = true; // bool | 
final int id = 56; // int | 
final List<int> idIn = ; // List<int> | Multiple values may be separated by commas.
final String nameIcontains = nameIcontains_example; // String | 
final String nameIendswith = nameIendswith_example; // String | 
final String nameIexact = nameIexact_example; // String | 
final String nameIstartswith = nameIstartswith_example; // String | 
final String ordering = ordering_example; // String | Which field to use when ordering the results.
final int page = 56; // int | A page number within the paginated result set.
final int pageSize = 56; // int | Number of results to return per page.

try {
    final response = api.correspondentsList(fullPerms, id, idIn, nameIcontains, nameIendswith, nameIexact, nameIstartswith, ordering, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CorrespondentsApi->correspondentsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fullPerms** | **bool**|  | [optional] 
 **id** | **int**|  | [optional] 
 **idIn** | [**List&lt;int&gt;**](int.md)| Multiple values may be separated by commas. | [optional] 
 **nameIcontains** | **String**|  | [optional] 
 **nameIendswith** | **String**|  | [optional] 
 **nameIexact** | **String**|  | [optional] 
 **nameIstartswith** | **String**|  | [optional] 
 **ordering** | **String**| Which field to use when ordering the results. | [optional] 
 **page** | **int**| A page number within the paginated result set. | [optional] 
 **pageSize** | **int**| Number of results to return per page. | [optional] 

### Return type

[**PaginatedCorrespondentList**](PaginatedCorrespondentList.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **correspondentsPartialUpdate**
> Correspondent correspondentsPartialUpdate(id, patchedCorrespondentRequest)



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

final api = PaperlessNgxApiV9().getCorrespondentsApi();
final int id = 56; // int | A unique integer value identifying this correspondent.
final PatchedCorrespondentRequest patchedCorrespondentRequest = ; // PatchedCorrespondentRequest | 

try {
    final response = api.correspondentsPartialUpdate(id, patchedCorrespondentRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CorrespondentsApi->correspondentsPartialUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this correspondent. | 
 **patchedCorrespondentRequest** | [**PatchedCorrespondentRequest**](PatchedCorrespondentRequest.md)|  | [optional] 

### Return type

[**Correspondent**](Correspondent.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **correspondentsRetrieve**
> Correspondent correspondentsRetrieve(id, fullPerms)



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

final api = PaperlessNgxApiV9().getCorrespondentsApi();
final int id = 56; // int | A unique integer value identifying this correspondent.
final bool fullPerms = true; // bool | 

try {
    final response = api.correspondentsRetrieve(id, fullPerms);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CorrespondentsApi->correspondentsRetrieve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this correspondent. | 
 **fullPerms** | **bool**|  | [optional] 

### Return type

[**Correspondent**](Correspondent.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **correspondentsUpdate**
> Correspondent correspondentsUpdate(id, correspondentRequest)



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

final api = PaperlessNgxApiV9().getCorrespondentsApi();
final int id = 56; // int | A unique integer value identifying this correspondent.
final CorrespondentRequest correspondentRequest = ; // CorrespondentRequest | 

try {
    final response = api.correspondentsUpdate(id, correspondentRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CorrespondentsApi->correspondentsUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this correspondent. | 
 **correspondentRequest** | [**CorrespondentRequest**](CorrespondentRequest.md)|  | 

### Return type

[**Correspondent**](Correspondent.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

