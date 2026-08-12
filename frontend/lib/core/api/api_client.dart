import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'endpoints.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Endpoints.baseUrl,
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  static Future<void> init() async {
    dio.interceptors.clear();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();

          if (token != null) {
            options.headers["Authorization"] =
            "Bearer $token";
          }

          handler.next(options);
        },
      ),
    );
  }
}