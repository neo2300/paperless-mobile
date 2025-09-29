# paperless_ngx_api_v9.api.MailAccountsApi

## Load the API package
```dart
import 'package:paperless_ngx_api_v9/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**mailAccountProcess**](MailAccountsApi.md#mailaccountprocess) | **POST** /api/mail_accounts/{id}/process/ | 
[**mailAccountTest**](MailAccountsApi.md#mailaccounttest) | **POST** /api/mail_accounts/test/ | 
[**mailAccountsCreate**](MailAccountsApi.md#mailaccountscreate) | **POST** /api/mail_accounts/ | 
[**mailAccountsDestroy**](MailAccountsApi.md#mailaccountsdestroy) | **DELETE** /api/mail_accounts/{id}/ | 
[**mailAccountsList**](MailAccountsApi.md#mailaccountslist) | **GET** /api/mail_accounts/ | 
[**mailAccountsPartialUpdate**](MailAccountsApi.md#mailaccountspartialupdate) | **PATCH** /api/mail_accounts/{id}/ | 
[**mailAccountsRetrieve**](MailAccountsApi.md#mailaccountsretrieve) | **GET** /api/mail_accounts/{id}/ | 
[**mailAccountsUpdate**](MailAccountsApi.md#mailaccountsupdate) | **PUT** /api/mail_accounts/{id}/ | 


# **mailAccountProcess**
> MailAccountProcessResponse mailAccountProcess(id, mailAccountRequest)



Manually process the selected mail account for new messages.

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

final api = PaperlessNgxApiV9().getMailAccountsApi();
final int id = 56; // int | A unique integer value identifying this mail account.
final MailAccountRequest mailAccountRequest = ; // MailAccountRequest | 

try {
    final response = api.mailAccountProcess(id, mailAccountRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling MailAccountsApi->mailAccountProcess: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this mail account. | 
 **mailAccountRequest** | [**MailAccountRequest**](MailAccountRequest.md)|  | 

### Return type

[**MailAccountProcessResponse**](MailAccountProcessResponse.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mailAccountTest**
> MailAccountTestResponse mailAccountTest(mailAccountRequest)



Test a mail account

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

final api = PaperlessNgxApiV9().getMailAccountsApi();
final MailAccountRequest mailAccountRequest = ; // MailAccountRequest | 

try {
    final response = api.mailAccountTest(mailAccountRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling MailAccountsApi->mailAccountTest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mailAccountRequest** | [**MailAccountRequest**](MailAccountRequest.md)|  | 

### Return type

[**MailAccountTestResponse**](MailAccountTestResponse.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mailAccountsCreate**
> MailAccount mailAccountsCreate(mailAccountRequest)



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

final api = PaperlessNgxApiV9().getMailAccountsApi();
final MailAccountRequest mailAccountRequest = ; // MailAccountRequest | 

try {
    final response = api.mailAccountsCreate(mailAccountRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling MailAccountsApi->mailAccountsCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mailAccountRequest** | [**MailAccountRequest**](MailAccountRequest.md)|  | 

### Return type

[**MailAccount**](MailAccount.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mailAccountsDestroy**
> mailAccountsDestroy(id)



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

final api = PaperlessNgxApiV9().getMailAccountsApi();
final int id = 56; // int | A unique integer value identifying this mail account.

try {
    api.mailAccountsDestroy(id);
} catch on DioException (e) {
    print('Exception when calling MailAccountsApi->mailAccountsDestroy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this mail account. | 

### Return type

void (empty response body)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mailAccountsList**
> PaginatedMailAccountList mailAccountsList(page, pageSize)



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

final api = PaperlessNgxApiV9().getMailAccountsApi();
final int page = 56; // int | A page number within the paginated result set.
final int pageSize = 56; // int | Number of results to return per page.

try {
    final response = api.mailAccountsList(page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling MailAccountsApi->mailAccountsList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**| A page number within the paginated result set. | [optional] 
 **pageSize** | **int**| Number of results to return per page. | [optional] 

### Return type

[**PaginatedMailAccountList**](PaginatedMailAccountList.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mailAccountsPartialUpdate**
> MailAccount mailAccountsPartialUpdate(id, patchedMailAccountRequest)



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

final api = PaperlessNgxApiV9().getMailAccountsApi();
final int id = 56; // int | A unique integer value identifying this mail account.
final PatchedMailAccountRequest patchedMailAccountRequest = ; // PatchedMailAccountRequest | 

try {
    final response = api.mailAccountsPartialUpdate(id, patchedMailAccountRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling MailAccountsApi->mailAccountsPartialUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this mail account. | 
 **patchedMailAccountRequest** | [**PatchedMailAccountRequest**](PatchedMailAccountRequest.md)|  | [optional] 

### Return type

[**MailAccount**](MailAccount.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mailAccountsRetrieve**
> MailAccount mailAccountsRetrieve(id)



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

final api = PaperlessNgxApiV9().getMailAccountsApi();
final int id = 56; // int | A unique integer value identifying this mail account.

try {
    final response = api.mailAccountsRetrieve(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling MailAccountsApi->mailAccountsRetrieve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this mail account. | 

### Return type

[**MailAccount**](MailAccount.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mailAccountsUpdate**
> MailAccount mailAccountsUpdate(id, mailAccountRequest)



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

final api = PaperlessNgxApiV9().getMailAccountsApi();
final int id = 56; // int | A unique integer value identifying this mail account.
final MailAccountRequest mailAccountRequest = ; // MailAccountRequest | 

try {
    final response = api.mailAccountsUpdate(id, mailAccountRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling MailAccountsApi->mailAccountsUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| A unique integer value identifying this mail account. | 
 **mailAccountRequest** | [**MailAccountRequest**](MailAccountRequest.md)|  | 

### Return type

[**MailAccount**](MailAccount.md)

### Authorization

[tokenAuth](../README.md#tokenAuth), [cookieAuth](../README.md#cookieAuth), [PaperelessBasicAuthentication](../README.md#PaperelessBasicAuthentication)

### HTTP request headers

 - **Content-Type**: application/json, application/x-www-form-urlencoded, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

