class Appointment {
  final int? id;
  final int patientId;
  final int doctorId;
  final String appointmentDate;
  final String reason;
  final String status;

  Appointment({
    this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.reason,
    this.status = "Pending",
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json["id"],
      patientId: json["patient_id"],
      doctorId: json["doctor_id"],
      appointmentDate: json["appointment_date"],
      reason: json["reason"],
      status: json["status"] ?? "Pending",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "patient_id": patientId,
      "doctor_id": doctorId,
      "appointment_date": appointmentDate,
      "reason": reason,
    };
  }
}