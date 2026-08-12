import 'package:flutter/material.dart';

import '../models/consultation.dart';
import '../services/consultation_service.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() =>
      _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {

  final service = ConsultationService();

  List<Consultation> consultations = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    consultations = await service.getMyConsultations();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consultation Records"),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: consultations.length,
        itemBuilder: (_, index) {
          final consultation = consultations[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.medical_services),
              title: Text(consultation.diagnosis),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(consultation.clinicalNotes),
                  const SizedBox(height: 5),
                  Text(
                    consultation.createdAt,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}