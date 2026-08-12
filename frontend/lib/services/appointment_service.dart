import 'package:dio/dio.dart';

import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../models/appointment.dart';

class AppointmentService {

  Future<void> bookAppointment(Appointment appointment) async {
    try {
      print("REQUEST: ${appointment.toJson()}");

      final response = await ApiClient.dio.post(
        "${Endpoints.appointments}/",
        data: appointment.toJson(),
      );

      print("SUCCESS: ${response.data}");
    } on DioException catch (e) {
      print("STATUS: ${e.response?.statusCode}");
      print("ERROR: ${e.response?.data}");
      rethrow;
    }
  }

  Future<List<Appointment>> getPatientAppointments(
      int patientId,
      ) async {

    final response = await ApiClient.dio.get(
      "${Endpoints.appointments}/patient/$patientId",
    );

    return (response.data as List)
        .map((e) => Appointment.fromJson(e))
        .toList();
  }

  Future<List<Appointment>> getDoctorAppointments(
      int doctorId,
      ) async {

    final response = await ApiClient.dio.get(
      "${Endpoints.appointments}/doctor/$doctorId",
    );

    return (response.data as List)
        .map((e) => Appointment.fromJson(e))
        .toList();
  }

  Future<void> updateStatus(
      int id,
      String status,
      ) async {
    try {
      final response = await ApiClient.dio.put(
        "${Endpoints.appointments}/$id/$status",
      );

      print("SUCCESS: ${response.data}");
    } on DioException catch (e) {
      print("STATUS CODE: ${e.response?.statusCode}");
      print("ERROR: ${e.response?.data}");
      rethrow;
    }
  }

  Future<void> deleteAppointment(int id) async {
    await ApiClient.dio.delete(
      "${Endpoints.appointments}/$id",
    );
  }
}