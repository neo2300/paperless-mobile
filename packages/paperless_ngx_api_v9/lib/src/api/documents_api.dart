//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:paperless_ngx_api_v9/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'dart:typed_data';
import 'package:paperless_ngx_api_v9/src/model/bulk_download.dart';
import 'package:paperless_ngx_api_v9/src/model/bulk_download_request.dart';
import 'package:paperless_ngx_api_v9/src/model/bulk_edit_documents_result.dart';
import 'package:paperless_ngx_api_v9/src/model/bulk_edit_request.dart';
import 'package:paperless_ngx_api_v9/src/model/document.dart';
import 'package:paperless_ngx_api_v9/src/model/document_request.dart';
import 'package:paperless_ngx_api_v9/src/model/document_share_links200_response_inner.dart';
import 'package:paperless_ngx_api_v9/src/model/email_request_request.dart';
import 'package:paperless_ngx_api_v9/src/model/email_response.dart';
import 'package:paperless_ngx_api_v9/src/model/metadata.dart';
import 'package:paperless_ngx_api_v9/src/model/note_create_request_request.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_document_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_log_entry_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_notes_list.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_document_request.dart';
import 'package:paperless_ngx_api_v9/src/model/selection_data.dart';
import 'package:paperless_ngx_api_v9/src/model/suggestions.dart';

class DocumentsApi {
  final Dio _dio;

  const DocumentsApi(this._dio);

  /// bulkEdit
  /// Perform a bulk edit operation on a list of documents
  ///
  /// Parameters:
  /// * [bulkEditRequest]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [BulkEditDocumentsResult] as data
  /// Throws [DioException] if API call or serialization fails
  /// Further documentation
  /// Also see [ Documentation](https://docs.paperless-ngx.com/api/#bulk-editing)
  Future<Response<BulkEditDocumentsResult>> bulkEdit({
    required BulkEditRequest bulkEditRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/bulk_edit/';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      _bodyData = jsonEncode(bulkEditRequest);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    BulkEditDocumentsResult? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<BulkEditDocumentsResult, BulkEditDocumentsResult>(
              rawData, 'BulkEditDocumentsResult',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<BulkEditDocumentsResult>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentShareLinks
  /// View share links for the document
  ///
  /// Parameters:
  /// * [id]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [List<DocumentShareLinks200ResponseInner>] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<List<DocumentShareLinks200ResponseInner>>>
      documentShareLinks({
    required String id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/{id}/share_links/'
        .replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    List<DocumentShareLinks200ResponseInner>? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<List<DocumentShareLinks200ResponseInner>,
                  DocumentShareLinks200ResponseInner>(
              rawData, 'List<DocumentShareLinks200ResponseInner>',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<List<DocumentShareLinks200ResponseInner>>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsBulkDownloadCreate
  ///
  ///
  /// Parameters:
  /// * [bulkDownloadRequest]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [BulkDownload] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<BulkDownload>> documentsBulkDownloadCreate({
    required BulkDownloadRequest bulkDownloadRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/bulk_download/';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      _bodyData = jsonEncode(bulkDownloadRequest);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    BulkDownload? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<BulkDownload, BulkDownload>(rawData, 'BulkDownload',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<BulkDownload>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsDestroy
  /// Pass a user object to serializer
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> documentsDestroy({
    required int id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path =
        r'/api/documents/{id}/'.replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'DELETE',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// documentsDownloadRetrieve
  /// Download the document
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [original]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Uint8List] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Uint8List>> documentsDownloadRetrieve({
    required int id,
    bool? original,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/{id}/download/'
        .replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'GET',
      responseType: ResponseType.bytes,
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (original != null) r'original': original,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Uint8List? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null ? null : rawData as Uint8List;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Uint8List>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsEmailCreate
  /// Email the document to one or more recipients as an attachment.
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [emailRequestRequest]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [EmailResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<EmailResponse>> documentsEmailCreate({
    required int id,
    required EmailRequestRequest emailRequestRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path =
        r'/api/documents/{id}/email/'.replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      _bodyData = jsonEncode(emailRequestRequest);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    EmailResponse? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<EmailResponse, EmailResponse>(rawData, 'EmailResponse',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<EmailResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsHistoryList
  /// View the document history
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [page] - A page number within the paginated result set.
  /// * [pageSize] - Number of results to return per page.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [PaginatedLogEntryList] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<PaginatedLogEntryList>> documentsHistoryList({
    required int id,
    int? page,
    int? pageSize,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/{id}/history/'
        .replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (page != null) r'page': page,
      if (pageSize != null) r'page_size': pageSize,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    PaginatedLogEntryList? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<PaginatedLogEntryList, PaginatedLogEntryList>(
              rawData, 'PaginatedLogEntryList',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<PaginatedLogEntryList>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsList
  /// Pass a user object to serializer
  ///
  /// Parameters:
  /// * [addedDateGt]
  /// * [addedDateGte]
  /// * [addedDateLt]
  /// * [addedDateLte]
  /// * [addedDay]
  /// * [addedGt]
  /// * [addedGte]
  /// * [addedLt]
  /// * [addedLte]
  /// * [addedMonth]
  /// * [addedYear]
  /// * [archiveSerialNumber]
  /// * [archiveSerialNumberGt]
  /// * [archiveSerialNumberGte]
  /// * [archiveSerialNumberIsnull]
  /// * [archiveSerialNumberLt]
  /// * [archiveSerialNumberLte]
  /// * [checksumIcontains]
  /// * [checksumIendswith]
  /// * [checksumIexact]
  /// * [checksumIstartswith]
  /// * [contentIcontains]
  /// * [contentIendswith]
  /// * [contentIexact]
  /// * [contentIstartswith]
  /// * [correspondentId]
  /// * [correspondentIdIn] - Multiple values may be separated by commas.
  /// * [correspondentIdNone]
  /// * [correspondentIsnull]
  /// * [correspondentNameIcontains]
  /// * [correspondentNameIendswith]
  /// * [correspondentNameIexact]
  /// * [correspondentNameIstartswith]
  /// * [createdDateGt]
  /// * [createdDateGte]
  /// * [createdDateLt]
  /// * [createdDateLte]
  /// * [createdDay]
  /// * [createdGt]
  /// * [createdGte]
  /// * [createdLt]
  /// * [createdLte]
  /// * [createdMonth]
  /// * [createdYear]
  /// * [customFieldQuery]
  /// * [customFieldsIcontains]
  /// * [customFieldsIdAll]
  /// * [customFieldsIdIn]
  /// * [customFieldsIdNone]
  /// * [documentTypeId]
  /// * [documentTypeIdIn] - Multiple values may be separated by commas.
  /// * [documentTypeIdNone]
  /// * [documentTypeIsnull]
  /// * [documentTypeNameIcontains]
  /// * [documentTypeNameIendswith]
  /// * [documentTypeNameIexact]
  /// * [documentTypeNameIstartswith]
  /// * [fields]
  /// * [fullPerms]
  /// * [hasCustomFields] - Has custom field
  /// * [id]
  /// * [idIn] - Multiple values may be separated by commas.
  /// * [isInInbox]
  /// * [isTagged] - Is tagged
  /// * [mimeType]
  /// * [modifiedDateGt]
  /// * [modifiedDateGte]
  /// * [modifiedDateLt]
  /// * [modifiedDateLte]
  /// * [modifiedDay]
  /// * [modifiedGt]
  /// * [modifiedGte]
  /// * [modifiedLt]
  /// * [modifiedLte]
  /// * [modifiedMonth]
  /// * [modifiedYear]
  /// * [ordering] - Which field to use when ordering the results.
  /// * [originalFilenameIcontains]
  /// * [originalFilenameIendswith]
  /// * [originalFilenameIexact]
  /// * [originalFilenameIstartswith]
  /// * [ownerId]
  /// * [ownerIdIn] - Multiple values may be separated by commas.
  /// * [ownerIdNone]
  /// * [ownerIsnull]
  /// * [page] - A page number within the paginated result set.
  /// * [pageSize] - Number of results to return per page.
  /// * [search] - A search term.
  /// * [sharedById]
  /// * [storagePathId]
  /// * [storagePathIdIn] - Multiple values may be separated by commas.
  /// * [storagePathIdNone]
  /// * [storagePathIsnull]
  /// * [storagePathNameIcontains]
  /// * [storagePathNameIendswith]
  /// * [storagePathNameIexact]
  /// * [storagePathNameIstartswith]
  /// * [tagsId]
  /// * [tagsIdAll]
  /// * [tagsIdIn]
  /// * [tagsIdNone]
  /// * [tagsNameIcontains]
  /// * [tagsNameIendswith]
  /// * [tagsNameIexact]
  /// * [tagsNameIstartswith]
  /// * [titleIcontains]
  /// * [titleIendswith]
  /// * [titleIexact]
  /// * [titleIstartswith]
  /// * [titleContent]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [PaginatedDocumentList] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<PaginatedDocumentList>> documentsList({
    DateTime? addedDateGt,
    DateTime? addedDateGte,
    DateTime? addedDateLt,
    DateTime? addedDateLte,
    num? addedDay,
    DateTime? addedGt,
    DateTime? addedGte,
    DateTime? addedLt,
    DateTime? addedLte,
    num? addedMonth,
    num? addedYear,
    int? archiveSerialNumber,
    int? archiveSerialNumberGt,
    int? archiveSerialNumberGte,
    bool? archiveSerialNumberIsnull,
    int? archiveSerialNumberLt,
    int? archiveSerialNumberLte,
    String? checksumIcontains,
    String? checksumIendswith,
    String? checksumIexact,
    String? checksumIstartswith,
    String? contentIcontains,
    String? contentIendswith,
    String? contentIexact,
    String? contentIstartswith,
    int? correspondentId,
    List<int>? correspondentIdIn,
    int? correspondentIdNone,
    bool? correspondentIsnull,
    String? correspondentNameIcontains,
    String? correspondentNameIendswith,
    String? correspondentNameIexact,
    String? correspondentNameIstartswith,
    DateTime? createdDateGt,
    DateTime? createdDateGte,
    DateTime? createdDateLt,
    DateTime? createdDateLte,
    num? createdDay,
    DateTime? createdGt,
    DateTime? createdGte,
    DateTime? createdLt,
    DateTime? createdLte,
    num? createdMonth,
    num? createdYear,
    String? customFieldQuery,
    String? customFieldsIcontains,
    int? customFieldsIdAll,
    int? customFieldsIdIn,
    int? customFieldsIdNone,
    int? documentTypeId,
    List<int>? documentTypeIdIn,
    int? documentTypeIdNone,
    bool? documentTypeIsnull,
    String? documentTypeNameIcontains,
    String? documentTypeNameIendswith,
    String? documentTypeNameIexact,
    String? documentTypeNameIstartswith,
    List<String>? fields,
    bool? fullPerms,
    bool? hasCustomFields,
    int? id,
    List<int>? idIn,
    bool? isInInbox,
    bool? isTagged,
    String? mimeType,
    DateTime? modifiedDateGt,
    DateTime? modifiedDateGte,
    DateTime? modifiedDateLt,
    DateTime? modifiedDateLte,
    num? modifiedDay,
    DateTime? modifiedGt,
    DateTime? modifiedGte,
    DateTime? modifiedLt,
    DateTime? modifiedLte,
    num? modifiedMonth,
    num? modifiedYear,
    String? ordering,
    String? originalFilenameIcontains,
    String? originalFilenameIendswith,
    String? originalFilenameIexact,
    String? originalFilenameIstartswith,
    int? ownerId,
    List<int>? ownerIdIn,
    int? ownerIdNone,
    bool? ownerIsnull,
    int? page,
    int? pageSize,
    String? search,
    bool? sharedById,
    int? storagePathId,
    List<int>? storagePathIdIn,
    int? storagePathIdNone,
    bool? storagePathIsnull,
    String? storagePathNameIcontains,
    String? storagePathNameIendswith,
    String? storagePathNameIexact,
    String? storagePathNameIstartswith,
    int? tagsId,
    int? tagsIdAll,
    int? tagsIdIn,
    int? tagsIdNone,
    String? tagsNameIcontains,
    String? tagsNameIendswith,
    String? tagsNameIexact,
    String? tagsNameIstartswith,
    String? titleIcontains,
    String? titleIendswith,
    String? titleIexact,
    String? titleIstartswith,
    String? titleContent,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (addedDateGt != null) r'added__date__gt': addedDateGt,
      if (addedDateGte != null) r'added__date__gte': addedDateGte,
      if (addedDateLt != null) r'added__date__lt': addedDateLt,
      if (addedDateLte != null) r'added__date__lte': addedDateLte,
      if (addedDay != null) r'added__day': addedDay,
      if (addedGt != null) r'added__gt': addedGt,
      if (addedGte != null) r'added__gte': addedGte,
      if (addedLt != null) r'added__lt': addedLt,
      if (addedLte != null) r'added__lte': addedLte,
      if (addedMonth != null) r'added__month': addedMonth,
      if (addedYear != null) r'added__year': addedYear,
      if (archiveSerialNumber != null)
        r'archive_serial_number': archiveSerialNumber,
      if (archiveSerialNumberGt != null)
        r'archive_serial_number__gt': archiveSerialNumberGt,
      if (archiveSerialNumberGte != null)
        r'archive_serial_number__gte': archiveSerialNumberGte,
      if (archiveSerialNumberIsnull != null)
        r'archive_serial_number__isnull': archiveSerialNumberIsnull,
      if (archiveSerialNumberLt != null)
        r'archive_serial_number__lt': archiveSerialNumberLt,
      if (archiveSerialNumberLte != null)
        r'archive_serial_number__lte': archiveSerialNumberLte,
      if (checksumIcontains != null) r'checksum__icontains': checksumIcontains,
      if (checksumIendswith != null) r'checksum__iendswith': checksumIendswith,
      if (checksumIexact != null) r'checksum__iexact': checksumIexact,
      if (checksumIstartswith != null)
        r'checksum__istartswith': checksumIstartswith,
      if (contentIcontains != null) r'content__icontains': contentIcontains,
      if (contentIendswith != null) r'content__iendswith': contentIendswith,
      if (contentIexact != null) r'content__iexact': contentIexact,
      if (contentIstartswith != null)
        r'content__istartswith': contentIstartswith,
      if (correspondentId != null) r'correspondent__id': correspondentId,
      if (correspondentIdIn != null)
        r'correspondent__id__in': correspondentIdIn,
      if (correspondentIdNone != null)
        r'correspondent__id__none': correspondentIdNone,
      if (correspondentIsnull != null)
        r'correspondent__isnull': correspondentIsnull,
      if (correspondentNameIcontains != null)
        r'correspondent__name__icontains': correspondentNameIcontains,
      if (correspondentNameIendswith != null)
        r'correspondent__name__iendswith': correspondentNameIendswith,
      if (correspondentNameIexact != null)
        r'correspondent__name__iexact': correspondentNameIexact,
      if (correspondentNameIstartswith != null)
        r'correspondent__name__istartswith': correspondentNameIstartswith,
      if (createdDateGt != null) r'created__date__gt': createdDateGt,
      if (createdDateGte != null) r'created__date__gte': createdDateGte,
      if (createdDateLt != null) r'created__date__lt': createdDateLt,
      if (createdDateLte != null) r'created__date__lte': createdDateLte,
      if (createdDay != null) r'created__day': createdDay,
      if (createdGt != null) r'created__gt': createdGt,
      if (createdGte != null) r'created__gte': createdGte,
      if (createdLt != null) r'created__lt': createdLt,
      if (createdLte != null) r'created__lte': createdLte,
      if (createdMonth != null) r'created__month': createdMonth,
      if (createdYear != null) r'created__year': createdYear,
      if (customFieldQuery != null) r'custom_field_query': customFieldQuery,
      if (customFieldsIcontains != null)
        r'custom_fields__icontains': customFieldsIcontains,
      if (customFieldsIdAll != null)
        r'custom_fields__id__all': customFieldsIdAll,
      if (customFieldsIdIn != null) r'custom_fields__id__in': customFieldsIdIn,
      if (customFieldsIdNone != null)
        r'custom_fields__id__none': customFieldsIdNone,
      if (documentTypeId != null) r'document_type__id': documentTypeId,
      if (documentTypeIdIn != null) r'document_type__id__in': documentTypeIdIn,
      if (documentTypeIdNone != null)
        r'document_type__id__none': documentTypeIdNone,
      if (documentTypeIsnull != null)
        r'document_type__isnull': documentTypeIsnull,
      if (documentTypeNameIcontains != null)
        r'document_type__name__icontains': documentTypeNameIcontains,
      if (documentTypeNameIendswith != null)
        r'document_type__name__iendswith': documentTypeNameIendswith,
      if (documentTypeNameIexact != null)
        r'document_type__name__iexact': documentTypeNameIexact,
      if (documentTypeNameIstartswith != null)
        r'document_type__name__istartswith': documentTypeNameIstartswith,
      if (fields != null) r'fields': fields,
      if (fullPerms != null) r'full_perms': fullPerms,
      if (hasCustomFields != null) r'has_custom_fields': hasCustomFields,
      if (id != null) r'id': id,
      if (idIn != null) r'id__in': idIn,
      if (isInInbox != null) r'is_in_inbox': isInInbox,
      if (isTagged != null) r'is_tagged': isTagged,
      if (mimeType != null) r'mime_type': mimeType,
      if (modifiedDateGt != null) r'modified__date__gt': modifiedDateGt,
      if (modifiedDateGte != null) r'modified__date__gte': modifiedDateGte,
      if (modifiedDateLt != null) r'modified__date__lt': modifiedDateLt,
      if (modifiedDateLte != null) r'modified__date__lte': modifiedDateLte,
      if (modifiedDay != null) r'modified__day': modifiedDay,
      if (modifiedGt != null) r'modified__gt': modifiedGt,
      if (modifiedGte != null) r'modified__gte': modifiedGte,
      if (modifiedLt != null) r'modified__lt': modifiedLt,
      if (modifiedLte != null) r'modified__lte': modifiedLte,
      if (modifiedMonth != null) r'modified__month': modifiedMonth,
      if (modifiedYear != null) r'modified__year': modifiedYear,
      if (ordering != null) r'ordering': ordering,
      if (originalFilenameIcontains != null)
        r'original_filename__icontains': originalFilenameIcontains,
      if (originalFilenameIendswith != null)
        r'original_filename__iendswith': originalFilenameIendswith,
      if (originalFilenameIexact != null)
        r'original_filename__iexact': originalFilenameIexact,
      if (originalFilenameIstartswith != null)
        r'original_filename__istartswith': originalFilenameIstartswith,
      if (ownerId != null) r'owner__id': ownerId,
      if (ownerIdIn != null) r'owner__id__in': ownerIdIn,
      if (ownerIdNone != null) r'owner__id__none': ownerIdNone,
      if (ownerIsnull != null) r'owner__isnull': ownerIsnull,
      if (page != null) r'page': page,
      if (pageSize != null) r'page_size': pageSize,
      if (search != null) r'search': search,
      if (sharedById != null) r'shared_by__id': sharedById,
      if (storagePathId != null) r'storage_path__id': storagePathId,
      if (storagePathIdIn != null) r'storage_path__id__in': storagePathIdIn,
      if (storagePathIdNone != null)
        r'storage_path__id__none': storagePathIdNone,
      if (storagePathIsnull != null) r'storage_path__isnull': storagePathIsnull,
      if (storagePathNameIcontains != null)
        r'storage_path__name__icontains': storagePathNameIcontains,
      if (storagePathNameIendswith != null)
        r'storage_path__name__iendswith': storagePathNameIendswith,
      if (storagePathNameIexact != null)
        r'storage_path__name__iexact': storagePathNameIexact,
      if (storagePathNameIstartswith != null)
        r'storage_path__name__istartswith': storagePathNameIstartswith,
      if (tagsId != null) r'tags__id': tagsId,
      if (tagsIdAll != null) r'tags__id__all': tagsIdAll,
      if (tagsIdIn != null) r'tags__id__in': tagsIdIn,
      if (tagsIdNone != null) r'tags__id__none': tagsIdNone,
      if (tagsNameIcontains != null)
        r'tags__name__icontains': tagsNameIcontains,
      if (tagsNameIendswith != null)
        r'tags__name__iendswith': tagsNameIendswith,
      if (tagsNameIexact != null) r'tags__name__iexact': tagsNameIexact,
      if (tagsNameIstartswith != null)
        r'tags__name__istartswith': tagsNameIstartswith,
      if (titleIcontains != null) r'title__icontains': titleIcontains,
      if (titleIendswith != null) r'title__iendswith': titleIendswith,
      if (titleIexact != null) r'title__iexact': titleIexact,
      if (titleIstartswith != null) r'title__istartswith': titleIstartswith,
      if (titleContent != null) r'title_content': titleContent,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    PaginatedDocumentList? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<PaginatedDocumentList, PaginatedDocumentList>(
              rawData, 'PaginatedDocumentList',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<PaginatedDocumentList>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsMetadataRetrieve
  /// View the document metadata
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Metadata] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Metadata>> documentsMetadataRetrieve({
    required int id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/{id}/metadata/'
        .replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Metadata? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<Metadata, Metadata>(rawData, 'Metadata',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Metadata>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsNextAsnRetrieve
  /// Get the next available Archive Serial Number (ASN) for a new document
  ///
  /// Parameters:
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [int] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<int>> documentsNextAsnRetrieve({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/next_asn/';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    int? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<int, int>(rawData, 'int', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<int>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsNotesCreate
  /// View, add, or delete notes for the document
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [noteCreateRequestRequest]
  /// * [id2] - Note ID to delete (used only for DELETE requests)
  /// * [page] - A page number within the paginated result set.
  /// * [pageSize] - Number of results to return per page.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [PaginatedNotesList] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<PaginatedNotesList>> documentsNotesCreate({
    required int id,
    required NoteCreateRequestRequest noteCreateRequestRequest,
    int? id2,
    int? page,
    int? pageSize,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path =
        r'/api/documents/{id}/notes/'.replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (id2 != null) r'id': id2,
      if (page != null) r'page': page,
      if (pageSize != null) r'page_size': pageSize,
    };

    dynamic _bodyData;

    try {
      _bodyData = jsonEncode(noteCreateRequestRequest);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(
          _dio.options,
          _path,
          queryParameters: _queryParameters,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    PaginatedNotesList? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<PaginatedNotesList, PaginatedNotesList>(
              rawData, 'PaginatedNotesList',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<PaginatedNotesList>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsNotesDestroy
  /// View, add, or delete notes for the document
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [id2] - Note ID to delete (used only for DELETE requests)
  /// * [page] - A page number within the paginated result set.
  /// * [pageSize] - Number of results to return per page.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [PaginatedNotesList] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<PaginatedNotesList>> documentsNotesDestroy({
    required int id,
    int? id2,
    int? page,
    int? pageSize,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path =
        r'/api/documents/{id}/notes/'.replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'DELETE',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (id2 != null) r'id': id2,
      if (page != null) r'page': page,
      if (pageSize != null) r'page_size': pageSize,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    PaginatedNotesList? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<PaginatedNotesList, PaginatedNotesList>(
              rawData, 'PaginatedNotesList',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<PaginatedNotesList>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsNotesList
  /// View, add, or delete notes for the document
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [id2] - Note ID to delete (used only for DELETE requests)
  /// * [page] - A page number within the paginated result set.
  /// * [pageSize] - Number of results to return per page.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [PaginatedNotesList] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<PaginatedNotesList>> documentsNotesList({
    required int id,
    int? id2,
    int? page,
    int? pageSize,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path =
        r'/api/documents/{id}/notes/'.replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (id2 != null) r'id': id2,
      if (page != null) r'page': page,
      if (pageSize != null) r'page_size': pageSize,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    PaginatedNotesList? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<PaginatedNotesList, PaginatedNotesList>(
              rawData, 'PaginatedNotesList',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<PaginatedNotesList>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsPartialUpdate
  /// Pass a user object to serializer
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [patchedDocumentRequest]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Document] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Document>> documentsPartialUpdate({
    required int id,
    PatchedDocumentRequest? patchedDocumentRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path =
        r'/api/documents/{id}/'.replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'PATCH',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      _bodyData = jsonEncode(patchedDocumentRequest);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Document? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<Document, Document>(rawData, 'Document',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Document>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsPostDocumentCreate
  /// Upload a document via the API
  ///
  /// Parameters:
  /// * [document]
  /// * [created]
  /// * [title]
  /// * [correspondent]
  /// * [documentType]
  /// * [storagePath]
  /// * [tags]
  /// * [archiveSerialNumber]
  /// * [customFields]
  /// * [fromWebui]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [String] as data
  /// Throws [DioException] if API call or serialization fails
  /// Further documentation
  /// Also see [ Documentation](https://docs.paperless-ngx.com/api/#file-uploads)
  Future<Response<String>> documentsPostDocumentCreate({
    required MultipartFile document,
    DateTime? created,
    String? title,
    int? correspondent,
    int? documentType,
    int? storagePath,
    List<int>? tags,
    int? archiveSerialNumber,
    List<int>? customFields,
    bool? fromWebui,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/post_document/';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      contentType: 'multipart/form-data',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {} catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    String? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<String, String>(rawData, 'String', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<String>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsPreviewRetrieve
  /// View the document preview
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Uint8List] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Uint8List>> documentsPreviewRetrieve({
    required int id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/{id}/preview/'
        .replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'GET',
      responseType: ResponseType.bytes,
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Uint8List? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null ? null : rawData as Uint8List;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Uint8List>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsRetrieve
  /// Retrieve a single document
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [fields]
  /// * [fullPerms]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Document] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Document>> documentsRetrieve({
    required int id,
    List<String>? fields,
    bool? fullPerms,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path =
        r'/api/documents/{id}/'.replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (fields != null) r'fields': fields,
      if (fullPerms != null) r'full_perms': fullPerms,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Document? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<Document, Document>(rawData, 'Document',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Document>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsSelectionDataCreate
  /// Get selection data for the selected documents
  ///
  /// Parameters:
  /// * [documents]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SelectionData] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SelectionData>> documentsSelectionDataCreate({
    required List<int> documents,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/selection_data/';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      contentType: 'multipart/form-data',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {} catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SelectionData? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<SelectionData, SelectionData>(rawData, 'SelectionData',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SelectionData>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsSuggestionsRetrieve
  /// View suggestions for the document
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Suggestions] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Suggestions>> documentsSuggestionsRetrieve({
    required int id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/documents/{id}/suggestions/'
        .replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Suggestions? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<Suggestions, Suggestions>(rawData, 'Suggestions',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Suggestions>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsThumbRetrieve
  /// View the document thumbnail
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Uint8List] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Uint8List>> documentsThumbRetrieve({
    required int id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path =
        r'/api/documents/{id}/thumb/'.replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'GET',
      responseType: ResponseType.bytes,
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Uint8List? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null ? null : rawData as Uint8List;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Uint8List>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// documentsUpdate
  /// Pass a user object to serializer
  ///
  /// Parameters:
  /// * [id] - A unique integer value identifying this document.
  /// * [documentRequest]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Document] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Document>> documentsUpdate({
    required int id,
    required DocumentRequest documentRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path =
        r'/api/documents/{id}/'.replaceAll('{' r'id' '}', id.toString());
    final _options = Options(
      method: r'PUT',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'tokenAuth',
            'keyName': 'Authorization',
            'where': 'header',
          },
          {
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': 'sessionid',
            'where': '',
          },
          {
            'type': 'http',
            'scheme': 'basic',
            'name': 'PaperelessBasicAuthentication',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      _bodyData = jsonEncode(documentRequest);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Document? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<Document, Document>(rawData, 'Document',
              growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Document>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }
}
