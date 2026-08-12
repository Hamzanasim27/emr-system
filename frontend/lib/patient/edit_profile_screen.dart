import 'package:flutter/material.dart';

import '../models/patient.dart';
import '../services/patient_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final service = PatientService();

  final gender = TextEditingController();
  final blood = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final emergency = TextEditingController();
  final allergies = TextEditingController();
  final history = TextEditingController();
  final medications = TextEditingController();
  final dob = TextEditingController();

  Patient? patient;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    patient = await service.getProfile();

    gender.text = patient!.gender;
    blood.text = patient!.bloodGroup;
    phone.text = patient!.phone;
    address.text = patient!.address;
    emergency.text = patient!.emergencyContact;
    allergies.text = patient!.allergies;
    history.text = patient!.medicalHistory;
    medications.text = patient!.currentMedications;
    dob.text = patient!.dateOfBirth;

    setState(() {
      loading = false;
    });
  }

  Future<void> save() async {
    await service.updateProfile(
      Patient(
        id: patient!.id,
        userId: patient!.userId,
        gender: gender.text,
        bloodGroup: blood.text,
        phone: phone.text,
        address: address.text,
        emergencyContact: emergency.text,
        allergies: allergies.text,
        medicalHistory: history.text,
        currentMedications: medications.text,
        dateOfBirth: dob.text,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Updated"),
      ),
    );

    Navigator.pop(context);
  }

  Widget field(String label, TextEditingController controller,
      {int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            field("Date of Birth", dob),
            field("Gender", gender),
            field("Blood Group", blood),
            field("Phone", phone),
            field("Address", address, lines: 2),
            field("Emergency Contact", emergency),
            field("Allergies", allergies, lines: 2),
            field("Medical History", history, lines: 3),
            field("Current Medications", medications, lines: 3),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: save,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}