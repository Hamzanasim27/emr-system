import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  static Future<String?> getToken() async {
    try {
      return await storage.read(key: "token");
    } catch (e) {
      await storage.deleteAll();
      return null;
    }
  }

  static Future<void> saveRole(String role) async {
    await storage.write(key: "role", value: role);
  }

  static Future<String?> getRole() async {
    try {
      return await storage.read(key: "role");
    } catch (e) {
      await storage.deleteAll();
      return null;
    }
  }

  static Future<void> saveUserId(int id) async {
    await storage.write(
      key: "user_id",
      value: id.toString(),
    );
  }

  static Future<int?> getUserId() async {
    final id = await storage.read(key: "user_id");

    if (id == null) return null;

    return int.parse(id);
  }

  static Future<void> savePatientId(int id) async {
    await storage.write(
      key: "patient_id",
      value: id.toString(),
    );
  }

  static Future<int?> getPatientId() async {
    final id = await storage.read(
      key: "patient_id",
    );

    if (id == null) return null;

    return int.parse(id);
  }

  static Future<void> clear() async {
    await storage.deleteAll();
  }
}