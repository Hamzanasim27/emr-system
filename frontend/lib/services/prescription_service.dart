import 'package:dio/dio.dart';

import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../models/prescription.dart';

class PrescriptionService {
  /// Doctor - Get prescriptions of a selected patient
  Future<List<Prescription>> getPrescriptions(int patientId) async {
    final response = await ApiClient.dio.get(
      "${Endpoints.prescriptions}/$patientId",
    );

    return (response.data as List)
        .map((e) => Prescription.fromJson(e))
        .toList();
  }

  /// Patient - Get my prescriptions
  Future<List<Prescription>> getMyPrescriptions() async {
    final response = await ApiClient.dio.get(
      "${Endpoints.prescriptions}/me",
    );

    return (response.data as List)
        .map((e) => Prescription.fromJson(e))
        .toList();
  }

  Future<void> createPrescription(
      Prescription prescription,
      ) async {
    try {
      await ApiClient.dio.post(
        "${Endpoints.prescriptions}/",
        data: prescription.toJson(),
      );
    } on DioException catch (e) {
      print(e.response?.data);
      rethrow;
    }
  }

  Future<void> deletePrescription(int id) async {
    await ApiClient.dio.delete(
      "${Endpoints.prescriptions}/$id",
    );
  }
}