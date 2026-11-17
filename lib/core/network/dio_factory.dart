import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:vernita/core/network/auth_interceptor.dart';
import 'package:vernita/core/storage/auth_token_storage.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Dio getDio(AuthTokenStorage tokenStorage) {
    if (_dio != null) return _dio!;

    // Short connect timeout: if the backend can't be reached we want to know
    // quickly instead of waiting 30s.
    final dio = Dio()
      ..options.connectTimeout = const Duration(seconds: 10)
      ..options.receiveTimeout = const Duration(seconds: 30);

    // Must be added first so every other interceptor sees the final headers.
    dio.interceptors.add(AuthInterceptor(tokenStorage));

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }

    _dio = dio;
    return dio;
  }
}
