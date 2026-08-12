import 'package:dio/dio.dart';

import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../models/clinical_note.dart';

class ClinicalNoteService {

  Future<List<ClinicalNote>> getNotes(int patientId) async {
    final response = await ApiClient.dio.get(
      "${Endpoints.clinicalNotes}/$patientId",
    );

    return (response.data as List)
        .map((e) => ClinicalNote.fromJson(e))
        .toList();
  }

  Future<void> addNote(ClinicalNote note) async {
    await ApiClient.dio.post(
      "${Endpoints.clinicalNotes}/",
      data: note.toJson(),
    );
  }

  Future<void> deleteNote(int id) async {
    await ApiClient.dio.delete(
      "${Endpoints.clinicalNotes}/$id",
    );
  }
}