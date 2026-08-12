import 'package:flutter/material.dart';

import '../models/consultation.dart';
import '../services/consultation_service.dart';

class ConsultationScreen extends StatefulWidget {
  final int patientId;

  const ConsultationScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<ConsultationScreen> createState() =>
      _ConsultationScreenState();
}

class _ConsultationScreenState
    extends State<ConsultationScreen> {

  final service = ConsultationService();

  List<Consultation> consultations = [];

  final diagnosis = TextEditingController();
  final notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    consultations =
    await service.getConsultations(widget.patientId);

    setState(() {});
  }

  Future<void> save() async {
    await service.addConsultation(
      patientId: widget.patientId,
      diagnosis: diagnosis.text,
      notes: notes.text,
    );

    diagnosis.clear();
    notes.clear();

    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consultation Records"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: diagnosis,
              decoration: const InputDecoration(
                labelText: "Diagnosis",
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: notes,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Clinical Notes",
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: save,
              child: const Text("Save Consultation"),
            ),

            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: consultations.length,
                itemBuilder: (_, index) {
                  final item = consultations[index];

                  return Card(
                    child: ListTile(
                      title: Text(item.diagnosis),
                      subtitle: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(item.clinicalNotes),
                          const SizedBox(height: 5),
                          Text(item.createdAt),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}