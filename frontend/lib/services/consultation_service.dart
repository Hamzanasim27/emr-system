import 'package:dio/dio.dart';

import '../core/api/api_client.dart';
import '../models/consultation.dart';

class ConsultationService {
  /// Doctor - Get consultations for a selected patient
  Future<List<Consultation>> getConsultations(int patientId) async {
    final response = await ApiClient.dio.get(
      "/consultations/$patientId",
    );

    return (response.data as List)
        .map((e) => Consultation.fromJson(e))
        .toList();
  }

  /// Patient - Get my consultations
  Future<List<Consultation>> getMyConsultations() async {
    final response = await ApiClient.dio.get(
      "/consultations/me",
    );

    return (response.data as List)
        .map((e) => Consultation.fromJson(e))
        .toList();
  }

  /// Doctor - Add consultation
  Future<void> addConsultation({
    required int patientId,
    required String diagnosis,
    required String notes,
  }) async {
    await ApiClient.dio.post(
      "/consultations/",
      data: {
        "patient_id": patientId,
        "diagnosis": diagnosis,
        "clinical_notes": notes,
      },
    );
  }
}