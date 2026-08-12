import 'package:dio/dio.dart';

import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../models/doctor_availability.dart';

class AvailabilityService {
  Future<List<DoctorAvailability>> getAvailability(int doctorId) async {
    final response = await ApiClient.dio.get(
      "${Endpoints.availability}$doctorId",
    );

    return (response.data as List)
        .map((e) => DoctorAvailability.fromJson(e))
        .toList();
  }

  Future<void> addAvailability(
      DoctorAvailability availability) async {
    print("Posting to: ${Endpoints.availability}");

    await ApiClient.dio.post(
      Endpoints.availability,
      data: availability.toJson(),
    );
  }

  Future<void> deleteAvailability(int id) async {
    await ApiClient.dio.delete(
      "${Endpoints.availability}$id",
    );
  }
}