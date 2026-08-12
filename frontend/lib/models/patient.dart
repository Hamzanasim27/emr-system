class Patient {
  final int? id;
  final int userId;

  final String gender;
  final String bloodGroup;
  final String phone;
  final String address;
  final String emergencyContact;
  final String allergies;
  final String medicalHistory;
  final String currentMedications;
  final String dateOfBirth;

  Patient({
    this.id,
    required this.userId,
    required this.gender,
    required this.bloodGroup,
    required this.phone,
    required this.address,
    required this.emergencyContact,
    required this.allergies,
    required this.medicalHistory,
    required this.currentMedications,
    required this.dateOfBirth,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json["id"],
      userId: json["user_id"],
      gender: json["gender"] ?? "",
      bloodGroup: json["blood_group"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
      emergencyContact: json["emergency_contact"] ?? "",
      allergies: json["allergies"] ?? "",
      medicalHistory: json["medical_history"] ?? "",
      currentMedications: json["current_medications"] ?? "",
      dateOfBirth: json["date_of_birth"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "gender": gender,
      "blood_group": bloodGroup,
      "phone": phone,
      "address": address,
      "emergency_contact": emergencyContact,
      "allergies": allergies,
      "medical_history": medicalHistory,
      "current_medications": currentMedications,
      "date_of_birth": dateOfBirth,
    };
  }
}