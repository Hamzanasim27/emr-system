class Doctor {
  final int id;
  final String fullName;
  final String email;
  final String role;

  Doctor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json["id"],
      fullName: json["full_name"],
      email: json["email"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "full_name": fullName,
      "email": email,
      "role": role,
    };
  }
}