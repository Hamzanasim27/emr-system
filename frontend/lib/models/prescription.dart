class Prescription {
  final int? id;
  final int patientId;
  final int doctorId;
  final String medicines;
  final String dosage;
  final String instructions;

  Prescription({
    this.id,
    required this.patientId,
    required this.doctorId,
    required this.medicines,
    required this.dosage,
    required this.instructions,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json["id"],
      patientId: json["patient_id"],
      doctorId: json["doctor_id"],
      medicines: json["medicines"],
      dosage: json["dosage"],
      instructions: json["instructions"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "patient_id": patientId,
      "doctor_id": doctorId,
      "medicines": medicines,
      "dosage": dosage,
      "instructions": instructions,
    };
  }
}