import 'package:dio/dio.dart';

import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../core/storage/token_storage.dart';

class AuthService {
  Future<void> login(
      String email,
      String password,
      ) async {
    final response = await ApiClient.dio.post(
      Endpoints.login,
      data: {
        "email": email,
        "password": password,
      },
    );

    final token = response.data["access_token"];
    final user = response.data["user"];

    await TokenStorage.saveToken(token);
    await TokenStorage.saveRole(user["role"]);
    await TokenStorage.saveUserId(user["id"]);

    if (response.data["patient_id"] != null) {
      await TokenStorage.savePatientId(
        response.data["patient_id"],
      );
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    await ApiClient.dio.post(
      Endpoints.register,
      data: {
        "full_name": fullName,
        "email": email,
        "password": password,
        "role": role,
      },
    );
  }

  Future<void> logout() async {
    await TokenStorage.clear();
  }
}