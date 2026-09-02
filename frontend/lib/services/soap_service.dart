import '../core/api/api_client.dart';

class SoapService {
  Future<Map<String, dynamic>> generateSoap(int consultationId) async {
    final response = await ApiClient.dio.post(
      "/soap/generate/$consultationId",
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> getSoapNote(int noteId) async {
    final response = await ApiClient.dio.get(
      "/soap/$noteId",
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<void> deleteSoapNote(int noteId) async {
    await ApiClient.dio.delete(
      "/soap/$noteId",
    );
  }
}