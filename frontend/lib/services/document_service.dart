import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../models/document.dart';

class DocumentService {
  Future<List<MedicalDocument>> getDocuments() async {
    final response = await ApiClient.dio.get("${Endpoints.documents}/me");

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
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    File file = File(result.files.single.path!);

    String name = result.files.single.name;

    FormData form = FormData.fromMap({
      "title": name,
      "file": await MultipartFile.fromFile(
        file.path,
        filename: name,
      ),
    });

    await ApiClient.dio.post(
      "${Endpoints.documents}/",
      data: form,
    );
  }
}