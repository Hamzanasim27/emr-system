import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../models/document.dart';

class DocumentService {
  Future<List<MedicalDocument>> getDocuments() async {
    final response = await ApiClient.dio.get(
      "${Endpoints.documents}/me",
    );

    return (response.data as List)
        .map((e) => MedicalDocument.fromJson(e))
        .toList();
  }

  Future<List<MedicalDocument>> getPatientDocuments(
      int patientId,
      ) async {
    final response = await ApiClient.dio.get(
      "${Endpoints.documents}/$patientId",
    );

    return (response.data as List)
        .map((e) => MedicalDocument.fromJson(e))
        .toList();
  }

  Future<void> upload() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
    );

    if (result == null) {
      debugPrint("UPLOAD: No file selected");
      return;
    }

    final pickedFile = result.files.single;

    if (pickedFile.bytes == null) {
      throw Exception("Could not read selected file");
    }

    final name = pickedFile.name;

    final form = FormData.fromMap({
      "title": name,
      "file": MultipartFile.fromBytes(
        pickedFile.bytes!,
        filename: name,
      ),
    });

    try {
      final response = await ApiClient.dio.post(
        "${Endpoints.documents}/",
        data: form,
      );

      debugPrint("UPLOAD STATUS: ${response.statusCode}");
      debugPrint("UPLOAD RESPONSE: ${response.data}");
    } on DioException catch (e) {
      debugPrint("UPLOAD ERROR: ${e.message}");
      debugPrint("UPLOAD STATUS: ${e.response?.statusCode}");
      debugPrint("UPLOAD RESPONSE: ${e.response?.data}");
      debugPrint("UPLOAD URL: ${e.requestOptions.uri}");

      rethrow;
    }
  }
}