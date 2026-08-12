import 'package:flutter/material.dart';

import '../core/storage/token_storage.dart';
import '../models/doctor_availability.dart';
import '../services/availability_service.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  final service = AvailabilityService();

  final dayController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();

  List<DoctorAvailability> availabilityList = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAvailability();
  }

  Future<void> loadAvailability() async {
    final doctorId = await TokenStorage.getUserId();

    if (doctorId == null) {
      setState(() {
        loading = false;
      });
      return;
    }

    availabilityList = await service.getAvailability(doctorId);

    setState(() {
      loading = false;
    });
  }

  Future<void> saveAvailability() async {
    final doctorId = await TokenStorage.getUserId();

    if (doctorId == null) return;

    if (dayController.text.isEmpty ||
        startController.text.isEmpty ||
        endController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    await service.addAvailability(
      DoctorAvailability(
        doctorId: doctorId,
        dayOfWeek: dayController.text,
        startTime: startController.text,
        endTime: endController.text,
      ),
    );

    dayController.clear();
    startController.clear();
    endController.clear();

    await loadAvailability();
  }

  Future<void> deleteAvailability(int id) async {
    await service.deleteAvailability(id);
    await loadAvailability();
  }

  @override
  void dispose() {
    dayController.dispose();
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Availability"),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: dayController,
              decoration: const InputDecoration(
                labelText: "Day (e.g. Monday)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: startController,
              decoration: const InputDecoration(
                labelText: "Start Time (09:00)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: endController,
              decoration: const InputDecoration(
                labelText: "End Time (17:00)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveAvailability,
                child: const Text("Save Availability"),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: availabilityList.length,
                itemBuilder: (context, index) {
                  final item = availabilityList[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(item.dayOfWeek),
                      subtitle: Text(
                        "${item.startTime} - ${item.endTime}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          deleteAvailability(item.id!);
                        },
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



