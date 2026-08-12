import 'package:flutter/material.dart';

import '../models/prescription.dart';
import '../services/prescription_service.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() =>
      _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final PrescriptionService service = PrescriptionService();

  List<Prescription> prescriptions = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      prescriptions = await service.getMyPrescriptions();
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Prescriptions"),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : prescriptions.isEmpty
          ? const Center(
        child: Text("No prescriptions found"),
      )
          : ListView.builder(
        itemCount: prescriptions.length,
        itemBuilder: (_, index) {
          final prescription = prescriptions[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(
                Icons.receipt_long,
                color: Colors.blue,
              ),
              title: Text(
                prescription.medicines,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    "Dosage: ${prescription.dosage}",
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Instructions: ${prescription.instructions}",
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