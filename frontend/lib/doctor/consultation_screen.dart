import 'package:flutter/material.dart';

import '../models/consultation.dart';
import '../services/consultation_service.dart';
import '../services/soap_service.dart';

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

  final consultationService = ConsultationService();
  final soapService = SoapService();

  final diagnosisController = TextEditingController();
  final notesController = TextEditingController();

  List<Consultation> consultations = [];

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    diagnosisController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> load() async {
    try {
      consultations =
      await consultationService.getConsultations(widget.patientId);

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load consultations: $e"),
        ),
      );
    }
  }

  Future<void> saveConsultation() async {
    if (diagnosisController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a diagnosis"),
        ),
      );
      return;
    }

    if (notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter clinical notes"),
        ),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await consultationService.addConsultation(
        patientId: widget.patientId,
        diagnosis: diagnosisController.text.trim(),
        notes: notesController.text.trim(),
      );

      diagnosisController.clear();
      notesController.clear();

      await load();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Consultation saved successfully"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save consultation: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  Future<void> generateSoap(Consultation consultation) async {
    if (consultation.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Consultation ID not found"),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(
                child: Text("Generating SOAP note..."),
              ),
            ],
          ),
        );
      },
    );

    try {
      final result =
      await soapService.generateSoap(consultation.id!);

      if (!mounted) return;

      Navigator.of(context).pop();

      final soapNote = result["soap_note"] ?? "";
      final noteId = result["id"];

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.auto_awesome),
                SizedBox(width: 8),
                Text("SOAP Note"),
              ],
            ),
            content: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                child: Text(
                  soapNote.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            noteId != null
                ? "SOAP note generated and saved"
                : "SOAP note generated",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("SOAP generation failed: $e"),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: diagnosisController,
              decoration: const InputDecoration(
                labelText: "Diagnosis",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: notesController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Clinical Notes",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saving ? null : saveConsultation,
                icon: saving
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.save),
                label: Text(
                  saving
                      ? "Saving..."
                      : "Save Consultation",
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Divider(),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Previous Consultations",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: loading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : consultations.isEmpty
                  ? const Center(
                child: Text(
                  "No consultation records found",
                ),
              )
                  : ListView.builder(
                itemCount: consultations.length,
                itemBuilder: (_, index) {
                  final consultation =
                  consultations[index];

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              const Icon(
                                Icons.medical_services,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  consultation.diagnosis,
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            consultation
                                .clinicalNotes,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            consultation.createdAt,
                            style:
                            const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  generateSoap(
                                    consultation,
                                  ),
                              icon: const Icon(
                                Icons.auto_awesome,
                              ),
                              label: const Text(
                                "Generate SOAP Note",
                              ),
                            ),
                          ),
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