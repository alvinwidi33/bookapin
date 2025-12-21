import 'package:dio/dio.dart';

class DioApiClient {
  static final DioApiClient _instance = DioApiClient._internal();
  factory DioApiClient() => _instance;

  late final Dio _dio;
  Dio get dio => _dio;

  DioApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://bukuacak-9bdcb4ef2605.herokuapp.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache',
        },

        validateStatus: (status) {
          return status != null && status >= 200 && status < 400;
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }
}
