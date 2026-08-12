import '../core/api/api_client.dart';
import '../models/doctor_patient.dart';
import '../models/doctor.dart';
import '../core/api/endpoints.dart';
class DoctorService {
  Future<List<DoctorPatient>> getPatients() async {
    final response = await ApiClient.dio.get("/doctor/patients");

    return (response.data as List)
        .map((e) => DoctorPatient.fromJson(e))
        .toList();
  }

  Future<List<Doctor>> getDoctors() async {
    final response = await ApiClient.dio.get(
      Endpoints.doctors,
    );

    return (response.data as List)
        .map((e) => Doctor.fromJson(e))
        .toList();
  }
}