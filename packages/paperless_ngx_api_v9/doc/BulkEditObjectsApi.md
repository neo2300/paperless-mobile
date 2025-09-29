# paperless_ngx_api_v9.api.BulkEditObjectsApi

## Load the API package
```dart
import 'package:paperless_ngx_api_v9/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bulkEditObjects**](BulkEditObjectsApi.md#bulkeditobjects) | **POST** /api/bulk_edit_objects/ | 


# **bulkEditObjects**
> BulkEditResult bulkEditObjects(bulkEditObjectsRequest)



Perform a bulk edit operation on a list of objects

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

final api = PaperlessNgxApiV9().getBulkEditObjectsApi();
final BulkEditObjectsRequest bulkEditObjectsRequest = ; // BulkEditObjectsRequest | 

try {
    final response = api.bulkEditObjects(bulkEditObjectsRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BulkEditObjectsApi->bulkEditObjects: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bulkEditObjectsRequest** | [**BulkEditObjectsRequest**](BulkEditObjectsRequest.md)|  | 

### Return type

[**BulkEditResult**](BulkEditResult.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

