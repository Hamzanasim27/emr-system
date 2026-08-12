import 'package:flutter/material.dart';

import '../core/storage/token_storage.dart';
import '../models/consultation.dart';
import '../models/document.dart';
import '../models/prescription.dart';

import '../services/consultation_service.dart';
import '../services/document_service.dart';
import '../services/prescription_service.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() =>
      _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState
    extends State<MedicalHistoryScreen> {
  final consultationService = ConsultationService();
  final prescriptionService = PrescriptionService();
  final documentService = DocumentService();

  List<Consultation> consultations = [];
  List<Prescription> prescriptions = [];
  List<MedicalDocument> documents = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final patientId = await TokenStorage.getPatientId();

    if (patientId == null) return;

    consultations =
    await consultationService.getConsultations(patientId);

    prescriptions =
    await prescriptionService.getPrescriptions(patientId);

    documents = await documentService.getDocuments();

    setState(() {
      loading = false;
    });
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
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
        title: const Text("Medical History"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          sectionTitle("Consultations"),

          if (consultations.isEmpty)
            const Text("No consultations found")
          else
            ...consultations.map(
                  (c) => Card(
                child: ListTile(
                  title: Text(c.diagnosis),
                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(c.clinicalNotes),
                      Text(c.createdAt),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 20),

          sectionTitle("Prescriptions"),

          if (prescriptions.isEmpty)
            const Text("No prescriptions found")
          else
            ...prescriptions.map(
                  (p) => Card(
                child: ListTile(
                  title: Text(p.medicines),
                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text("Dosage: ${p.dosage}"),
                      Text(p.instructions),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 20),

          sectionTitle("Medical Documents"),

          if (documents.isEmpty)
            const Text("No uploaded documents")
          else
            ...documents.map(
                  (d) => Card(
                child: ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(d.title),
                  subtitle: Text(d.fileName),
                ),
              ),
            ),
        ],
      ),
    );
  }
}