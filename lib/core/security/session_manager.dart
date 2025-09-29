import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

abstract interface class SessionManager implements ChangeNotifier {
  Dio get client;

  void updateSettings({
    String? baseUrl,
    String? authToken,
    ClientCertificate? clientCertificate,
  });
  void resetSettings();
}
