class DoctorAvailability {
  final int? id;
  final int doctorId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  DoctorAvailability({
    this.id,
    required this.doctorId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory DoctorAvailability.fromJson(Map<String, dynamic> json) {
    return DoctorAvailability(
      id: json["id"],
      doctorId: json["doctor_id"],
      dayOfWeek: json["day_of_week"],
      startTime: json["start_time"],
      endTime: json["end_time"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "doctor_id": doctorId,
      "day_of_week": dayOfWeek,
      "start_time": startTime,
      "end_time": endTime,
    };
  }
}