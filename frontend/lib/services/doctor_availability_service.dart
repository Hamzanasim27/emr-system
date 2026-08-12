import 'package:dio/dio.dart';

import '../core/api/api_client.dart';
import '../models/doctor_availability.dart';
import '../core/api/endpoints.dart';
class DoctorAvailabilityService {
  Future<List<DoctorAvailability>> getAvailability(
      int doctorId) async {

    final response = await ApiClient.dio.get(
      "/availability/$doctorId",
    );

    return (response.data as List)
        .map((e) => DoctorAvailability.fromJson(e))
        .toList();
  }
}