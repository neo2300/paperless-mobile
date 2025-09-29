# paperless_ngx_api_v9.api.ShareLinksApi

## Load the API package
```dart
import 'package:paperless_ngx_api_v9/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**shareLinksCreate**](ShareLinksApi.md#sharelinkscreate) | **POST** /api/share_links/ | 
[**shareLinksDestroy**](ShareLinksApi.md#sharelinksdestroy) | **DELETE** /api/share_links/{id}/ | 
[**shareLinksList**](ShareLinksApi.md#sharelinkslist) | **GET** /api/share_links/ | 
[**shareLinksPartialUpdate**](ShareLinksApi.md#sharelinkspartialupdate) | **PATCH** /api/share_links/{id}/ | 
[**shareLinksRetrieve**](ShareLinksApi.md#sharelinksretrieve) | **GET** /api/share_links/{id}/ | 
[**shareLinksUpdate**](ShareLinksApi.md#sharelinksupdate) | **PUT** /api/share_links/{id}/ | 


# **shareLinksCreate**
> ShareLink shareLinksCreate(shareLinkRequest)



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

final api = PaperlessNgxApiV9().getShareLinksApi();
final ShareLinkRequest shareLinkRequest = ; // ShareLinkRequest | 

try {
    final response = api.shareLinksCreate(shareLinkRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ShareLinksApi->shareLinksCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **shareLinkRequest** | [**ShareLinkRequest**](ShareLinkRequest.md)|  | [optional] 

### Return type

[**ShareLink**](ShareLink.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shareLinksDestroy**
> shareLinksDestroy(id)



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

final api = PaperlessNgxApiV9().getShareLinksApi();
final int id = 56; // int | A unique integer value identifying this share link.

try {
    api.shareLinksDestroy(id);
} catch on DioException (e) {
    print('Exception when calling ShareLinksApi->shareLinksDestroy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this share link. | 

### Return type

void (empty response body)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shareLinksList**
> PaginatedShareLinkList shareLinksList(createdDateGt, createdDateGte, createdDateLt, createdDateLte, createdDay, createdGt, createdGte, createdLt, createdLte, createdMonth, createdYear, expirationDateGt, expirationDateGte, expirationDateLt, expirationDateLte, expirationDay, expirationGt, expirationGte, expirationLt, expirationLte, expirationMonth, expirationYear, ordering, page, pageSize)



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

final api = PaperlessNgxApiV9().getShareLinksApi();
final DateTime createdDateGt = 2013-10-20; // DateTime | 
final DateTime createdDateGte = 2013-10-20; // DateTime | 
final DateTime createdDateLt = 2013-10-20; // DateTime | 
final DateTime createdDateLte = 2013-10-20; // DateTime | 
final num createdDay = 8.14; // num | 
final DateTime createdGt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime createdGte = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime createdLt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime createdLte = 2013-10-20T19:20:30+01:00; // DateTime | 
final num createdMonth = 8.14; // num | 
final num createdYear = 8.14; // num | 
final DateTime expirationDateGt = 2013-10-20; // DateTime | 
final DateTime expirationDateGte = 2013-10-20; // DateTime | 
final DateTime expirationDateLt = 2013-10-20; // DateTime | 
final DateTime expirationDateLte = 2013-10-20; // DateTime | 
final num expirationDay = 8.14; // num | 
final DateTime expirationGt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime expirationGte = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime expirationLt = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime expirationLte = 2013-10-20T19:20:30+01:00; // DateTime | 
final num expirationMonth = 8.14; // num | 
final num expirationYear = 8.14; // num | 
final String ordering = ordering_example; // String | Which field to use when ordering the results.
final int page = 56; // int | A page number within the paginated result set.
final int pageSize = 56; // int | Number of results to return per page.

try {
    final response = api.shareLinksList(createdDateGt, createdDateGte, createdDateLt, createdDateLte, createdDay, createdGt, createdGte, createdLt, createdLte, createdMonth, createdYear, expirationDateGt, expirationDateGte, expirationDateLt, expirationDateLte, expirationDay, expirationGt, expirationGte, expirationLt, expirationLte, expirationMonth, expirationYear, ordering, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ShareLinksApi->shareLinksList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
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
 **expirationDateGt** | **DateTime**|  | [optional] 
 **expirationDateGte** | **DateTime**|  | [optional] 
 **expirationDateLt** | **DateTime**|  | [optional] 
 **expirationDateLte** | **DateTime**|  | [optional] 
 **expirationDay** | **num**|  | [optional] 
 **expirationGt** | **DateTime**|  | [optional] 
 **expirationGte** | **DateTime**|  | [optional] 
 **expirationLt** | **DateTime**|  | [optional] 
 **expirationLte** | **DateTime**|  | [optional] 
 **expirationMonth** | **num**|  | [optional] 
 **expirationYear** | **num**|  | [optional] 
 **ordering** | **String**| Which field to use when ordering the results. | [optional] 
 **page** | **int**| A page number within the paginated result set. | [optional] 
 **pageSize** | **int**| Number of results to return per page. | [optional] 

### Return type

[**PaginatedShareLinkList**](PaginatedShareLinkList.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shareLinksPartialUpdate**
> ShareLink shareLinksPartialUpdate(id, patchedShareLinkRequest)



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

final api = PaperlessNgxApiV9().getShareLinksApi();
final int id = 56; // int | A unique integer value identifying this share link.
final PatchedShareLinkRequest patchedShareLinkRequest = ; // PatchedShareLinkRequest | 

try {
    final response = api.shareLinksPartialUpdate(id, patchedShareLinkRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ShareLinksApi->shareLinksPartialUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this share link. | 
 **patchedShareLinkRequest** | [**PatchedShareLinkRequest**](PatchedShareLinkRequest.md)|  | [optional] 

### Return type

[**ShareLink**](ShareLink.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shareLinksRetrieve**
> ShareLink shareLinksRetrieve(id)



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

final api = PaperlessNgxApiV9().getShareLinksApi();
final int id = 56; // int | A unique integer value identifying this share link.

try {
    final response = api.shareLinksRetrieve(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ShareLinksApi->shareLinksRetrieve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this share link. | 

### Return type

[**ShareLink**](ShareLink.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shareLinksUpdate**
> ShareLink shareLinksUpdate(id, shareLinkRequest)



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

final api = PaperlessNgxApiV9().getShareLinksApi();
final int id = 56; // int | A unique integer value identifying this share link.
final ShareLinkRequest shareLinkRequest = ; // ShareLinkRequest | 

try {
    final response = api.shareLinksUpdate(id, shareLinkRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ShareLinksApi->shareLinksUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this share link. | 
 **shareLinkRequest** | [**ShareLinkRequest**](ShareLinkRequest.md)|  | [optional] 

### Return type

[**ShareLink**](ShareLink.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

