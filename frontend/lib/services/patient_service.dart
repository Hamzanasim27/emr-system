import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../models/patient.dart';

class PatientService {

  Future<Patient> getProfile() async {
    final response = await ApiClient.dio.get("${Endpoints.patients}/me");

    print(response.statusCode);
    print(response.data);

    return Patient.fromJson(response.data);
  }

  Future<void> updateProfile(Patient patient) async {

    await ApiClient.dio.put(
      "${Endpoints.patients}/me",
      data: patient.toJson(),
    );
  }
}