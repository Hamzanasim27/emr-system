import 'package:flutter/material.dart';

import '../models/consultation.dart';
import '../services/consultation_service.dart';
import 'soap_note_screen.dart';

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
    try {
      final data = await service.getMyConsultations();

      if (!mounted) return;

      setState(() {
        consultations = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to load consultations"),
        ),
      );
    }
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
          : consultations.isEmpty
          ? const Center(
        child: Text("No consultation records found."),
      )
          : RefreshIndicator(
        onRefresh: load,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: consultations.length,
          itemBuilder: (_, index) {
            final consultation = consultations[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.medical_services,
                      ),
                      title: Text(
                        consultation.diagnosis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          Text(
                            consultation.clinicalNotes,
                          ),

                          const SizedBox(height: 8),

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

                    if (consultation.soapNoteId != null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.description,
                          ),
                          label: const Text(
                            "View SOAP Note",
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SoapNoteScreen(
                                      noteId:
                                      consultation.soapNoteId!,
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
          },
        ),
      ),
    );
  }
}