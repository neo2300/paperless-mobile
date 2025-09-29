# paperless_ngx_api_v9.api.CustomFieldsApi

## Load the API package
```dart
import 'package:paperless_ngx_api_v9/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**customFieldsCreate**](CustomFieldsApi.md#customfieldscreate) | **POST** /api/custom_fields/ | 
[**customFieldsDestroy**](CustomFieldsApi.md#customfieldsdestroy) | **DELETE** /api/custom_fields/{id}/ | 
[**customFieldsList**](CustomFieldsApi.md#customfieldslist) | **GET** /api/custom_fields/ | 
[**customFieldsPartialUpdate**](CustomFieldsApi.md#customfieldspartialupdate) | **PATCH** /api/custom_fields/{id}/ | 
[**customFieldsRetrieve**](CustomFieldsApi.md#customfieldsretrieve) | **GET** /api/custom_fields/{id}/ | 
[**customFieldsUpdate**](CustomFieldsApi.md#customfieldsupdate) | **PUT** /api/custom_fields/{id}/ | 


# **customFieldsCreate**
> CustomField customFieldsCreate(customFieldRequest)



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

final api = PaperlessNgxApiV9().getCustomFieldsApi();
final CustomFieldRequest customFieldRequest = ; // CustomFieldRequest | 

try {
    final response = api.customFieldsCreate(customFieldRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CustomFieldsApi->customFieldsCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **customFieldRequest** | [**CustomFieldRequest**](CustomFieldRequest.md)|  | 

### Return type

[**CustomField**](CustomField.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customFieldsDestroy**
> customFieldsDestroy(id)



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

final api = PaperlessNgxApiV9().getCustomFieldsApi();
final int id = 56; // int | A unique integer value identifying this custom field.

try {
    api.customFieldsDestroy(id);
} catch on DioException (e) {
    print('Exception when calling CustomFieldsApi->customFieldsDestroy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this custom field. | 

### Return type

void (empty response body)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customFieldsList**
> PaginatedCustomFieldList customFieldsList(id, idIn, nameIcontains, nameIendswith, nameIexact, nameIstartswith, ordering, page, pageSize)



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

final api = PaperlessNgxApiV9().getCustomFieldsApi();
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
    final response = api.customFieldsList(id, idIn, nameIcontains, nameIendswith, nameIexact, nameIstartswith, ordering, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CustomFieldsApi->customFieldsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
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

[**PaginatedCustomFieldList**](PaginatedCustomFieldList.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customFieldsPartialUpdate**
> CustomField customFieldsPartialUpdate(id, patchedCustomFieldRequest)



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

final api = PaperlessNgxApiV9().getCustomFieldsApi();
final int id = 56; // int | A unique integer value identifying this custom field.
final PatchedCustomFieldRequest patchedCustomFieldRequest = ; // PatchedCustomFieldRequest | 

try {
    final response = api.customFieldsPartialUpdate(id, patchedCustomFieldRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CustomFieldsApi->customFieldsPartialUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this custom field. | 
 **patchedCustomFieldRequest** | [**PatchedCustomFieldRequest**](PatchedCustomFieldRequest.md)|  | [optional] 

### Return type

[**CustomField**](CustomField.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customFieldsRetrieve**
> CustomField customFieldsRetrieve(id)



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

final api = PaperlessNgxApiV9().getCustomFieldsApi();
final int id = 56; // int | A unique integer value identifying this custom field.

try {
    final response = api.customFieldsRetrieve(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CustomFieldsApi->customFieldsRetrieve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this custom field. | 

### Return type

[**CustomField**](CustomField.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **customFieldsUpdate**
> CustomField customFieldsUpdate(id, customFieldRequest)



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

final api = PaperlessNgxApiV9().getCustomFieldsApi();
final int id = 56; // int | A unique integer value identifying this custom field.
final CustomFieldRequest customFieldRequest = ; // CustomFieldRequest | 

try {
    final response = api.customFieldsUpdate(id, customFieldRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CustomFieldsApi->customFieldsUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this custom field. | 
 **customFieldRequest** | [**CustomFieldRequest**](CustomFieldRequest.md)|  | 

### Return type

[**CustomField**](CustomField.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

