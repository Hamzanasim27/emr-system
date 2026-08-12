import 'package:flutter/material.dart';

import '../models/doctor_patient.dart';
import '../services/doctor_service.dart';

import 'consultation_screen.dart';
import 'prescription_screen.dart';
import 'clinical_notes_screen.dart';
import 'patient_documents_screen.dart';

class AuthorizedPatientsScreen extends StatefulWidget {
  final String action;

  const AuthorizedPatientsScreen({
    super.key,
    required this.action,
  });

  @override
  State<AuthorizedPatientsScreen> createState() =>
      _AuthorizedPatientsScreenState();
}

class _AuthorizedPatientsScreenState
    extends State<AuthorizedPatientsScreen> {

  final service = DoctorService();

  List<DoctorPatient> patients = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  Future<void> loadPatients() async {
    patients = await service.getPatients();

    setState(() {
      loading = false;
    });
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
        title: const Text("Authorized Patients"),
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (_, index) {

          final patient = patients[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(patient.fullName),
              subtitle: Text(patient.email),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {

                if (widget.action == "consultation") {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConsultationScreen(
                        patientId: patient.id,
                      ),
                    ),
                  );

                } else if (widget.action == "prescription") {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrescriptionScreen(
                        patientId: patient.id,
                      ),
                    ),
                  );

                } else if (widget.action == "documents") {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DoctorDocumentScreen(
                        patientId: patient.id,
                      ),
                    ),
                  );

                } else if (widget.action == "notes") {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClinicalNoteScreen(
                        patientId: patient.id,
                      ),
                    ),
                  );

                }

              },
            ),
          );
        },
      ),
    );
  }
}