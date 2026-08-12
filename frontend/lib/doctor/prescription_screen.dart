import 'package:flutter/material.dart';

import '../core/storage/token_storage.dart';
import '../models/prescription.dart';
import '../services/prescription_service.dart';

class PrescriptionScreen extends StatefulWidget {

  final int patientId;

  const PrescriptionScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<PrescriptionScreen> createState() =>
      _PrescriptionScreenState();
}

class _PrescriptionScreenState
    extends State<PrescriptionScreen> {

  final service = PrescriptionService();

  final medicines = TextEditingController();
  final dosage = TextEditingController();
  final instructions = TextEditingController();

  List<Prescription> prescriptions = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {

    prescriptions =
    await service.getPrescriptions(
      widget.patientId,
    );

    setState(() {
      loading = false;
    });
  }

  Future<void> save() async {
    final doctorId = await TokenStorage.getUserId();

    print("Doctor ID: $doctorId");

    if (doctorId == null) {
      print("Doctor ID is NULL");
      return;
    }

    try {
      final prescription = Prescription(
        patientId: widget.patientId,
        doctorId: doctorId,
        medicines: medicines.text,
        dosage: dosage.text,
        instructions: instructions.text,
      );

      print(prescription.toJson());

      await service.createPrescription(prescription);

      print("Prescription Saved");

      medicines.clear();
      dosage.clear();
      instructions.clear();

      load();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Prescriptions"),
      ),

      body: loading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : Padding(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: medicines,
              decoration:
              const InputDecoration(
                labelText:
                "Medicines",
              ),
            ),

            TextField(
              controller: dosage,
              decoration:
              const InputDecoration(
                labelText:
                "Dosage",
              ),
            ),

            TextField(
              controller:
              instructions,
              decoration:
              const InputDecoration(
                labelText:
                "Instructions",
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: save,
              child: const Text(
                  "Save Prescription"),
            ),

            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount:
                prescriptions.length,
                itemBuilder:
                    (_, index) {

                  final p =
                  prescriptions[index];

                  return Card(
                    child: ListTile(
                      title:
                      Text(p.medicines),
                      subtitle: Text(
                          "${p.dosage}\n${p.instructions}"),
                      trailing:
                      IconButton(
                        icon: const Icon(
                            Icons.delete),
                        onPressed:
                            () async {

                          await service
                              .deletePrescription(
                              p.id!);

                          load();
                        },
                      ),
                    ),
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}