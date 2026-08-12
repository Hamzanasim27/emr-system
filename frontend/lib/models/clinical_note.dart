class ClinicalNote {
  final int? id;
  final int patientId;
  final int doctorId;
  final String note;

  ClinicalNote({
    this.id,
    required this.patientId,
    required this.doctorId,
    required this.note,
  });

  factory ClinicalNote.fromJson(Map<String, dynamic> json) {
    return ClinicalNote(
      id: json["id"],
      patientId: json["patient_id"],
      doctorId: json["doctor_id"],
      note: json["note"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "patient_id": patientId,
      "doctor_id": doctorId,
      "note": note,
    };
  }
}