class DoctorPatient {
  final int id;
  final int userId;
  final String fullName;
  final String email;
  final String gender;
  final String bloodGroup;

  DoctorPatient({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.gender,
    required this.bloodGroup,
  });

  factory DoctorPatient.fromJson(Map<String, dynamic> json) {
    return DoctorPatient(
      id: json["id"],
      userId: json["user_id"],
      fullName: json["full_name"] ?? "",
      email: json["email"] ?? "",
      gender: json["gender"] ?? "",
      bloodGroup: json["blood_group"] ?? "",
    );
  }
}