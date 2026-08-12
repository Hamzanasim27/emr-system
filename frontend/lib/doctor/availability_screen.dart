import 'package:flutter/material.dart';

import '../core/storage/token_storage.dart';
import '../models/doctor_availability.dart';
import '../services/availability_service.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() =>
      _AvailabilityScreenState();
}

class _AvailabilityScreenState
    extends State<AvailabilityScreen> {
  final service = AvailabilityService();

  final dayController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();

  List<DoctorAvailability> availabilityList = [];

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadAvailability();
  }

  Future<void> loadAvailability() async {
    try {
      final doctorId = await TokenStorage.getUserId();

      if (!mounted) return;

      if (doctorId == null) {
        setState(() {
          loading = false;
        });
        return;
      }

      final result = await service.getAvailability(doctorId);

      if (!mounted) return;

      setState(() {
        availabilityList = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load availability: $e"),
        ),
      );
    }
  }

  Future<void> saveAvailability() async {
    final doctorId = await TokenStorage.getUserId();

    if (!mounted) return;

    if (doctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Doctor not found"),
        ),
      );
      return;
    }

    if (dayController.text.trim().isEmpty ||
        startController.text.trim().isEmpty ||
        endController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await service.addAvailability(
        DoctorAvailability(
          doctorId: doctorId,
          dayOfWeek: dayController.text.trim(),
          startTime: startController.text.trim(),
          endTime: endController.text.trim(),
        ),
      );

      if (!mounted) return;

      dayController.clear();
      startController.clear();
      endController.clear();

      setState(() {
        saving = false;
      });

      await loadAvailability();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save availability: $e"),
        ),
      );
    }
  }

  Future<void> deleteAvailability(int id) async {
    try {
      await service.deleteAvailability(id);

      if (!mounted) return;

      await loadAvailability();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete availability: $e"),
        ),
      );
    }
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
              enabled: !saving,
              decoration: const InputDecoration(
                labelText: "Day (e.g. Monday)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: startController,
              enabled: !saving,
              decoration: const InputDecoration(
                labelText: "Start Time (09:00)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: endController,
              enabled: !saving,
              decoration: const InputDecoration(
                labelText: "End Time (17:00)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                saving ? null : saveAvailability,
                child: saving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text("Save Availability"),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: availabilityList.isEmpty
                  ? const Center(
                child: Text(
                  "No availability added yet",
                ),
              )
                  : ListView.builder(
                itemCount: availabilityList.length,
                itemBuilder: (context, index) {
                  final item =
                  availabilityList[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.schedule,
                      ),
                      title: Text(item.dayOfWeek),
                      subtitle: Text(
                        "${item.startTime} - "
                            "${item.endTime}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: saving ||
                            item.id == null
                            ? null
                            : () {
                          deleteAvailability(
                            item.id!,
                          );
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