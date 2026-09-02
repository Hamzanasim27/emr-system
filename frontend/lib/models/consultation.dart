class Consultation {
  final int? id;
  final int patientId;
  final int doctorId;
  final String diagnosis;
  final String clinicalNotes;
  final String createdAt;
  final int? soapNoteId;

  Consultation({
    this.id,
    required this.patientId,
    required this.doctorId,
    required this.diagnosis,
    required this.clinicalNotes,
    required this.createdAt,
    this.soapNoteId,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json["id"],
      patientId: json["patient_id"],
      doctorId: json["doctor_id"],
      diagnosis: json["diagnosis"] ?? "",
      clinicalNotes: json["clinical_notes"] ?? "",
      createdAt: json["created_at"] ?? "",
      soapNoteId: json["soap_note_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "patient_id": patientId,
      "diagnosis": diagnosis,
      "clinical_notes": clinicalNotes,
    };
  }
}