import 'dart:io';

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
    FilePickerResult? result =
    await FilePicker.platform.pickFiles();

    if (result == null) {
      debugPrint("UPLOAD: No file selected");
      return;
    }

    final filePath = result.files.single.path;

    if (filePath == null) {
      debugPrint("UPLOAD: File path is unavailable");
      return;
    }

    final file = File(filePath);
    final name = result.files.single.name;

    debugPrint("UPLOAD FILE: $name");
    debugPrint(
      "UPLOAD API: ${Endpoints.baseUrl}${Endpoints.documents}/",
    );

    final form = FormData.fromMap({
      "title": name,
      "file": await MultipartFile.fromFile(
        file.path,
        filename: name,
      ),
    });

    try {
      final response = await ApiClient.dio.post(
        "${Endpoints.documents}/",
        data: form,
      );

      debugPrint("UPLOAD SUCCESS: ${response.statusCode}");
      debugPrint("UPLOAD RESPONSE: ${response.data}");
    } on DioException catch (e) {
      debugPrint("UPLOAD STATUS: ${e.response?.statusCode}");
      debugPrint("UPLOAD RESPONSE: ${e.response?.data}");
      debugPrint("UPLOAD URL: ${e.requestOptions.uri}");
      debugPrint("UPLOAD ERROR: ${e.message}");

      rethrow;
    }
  }
}