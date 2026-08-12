import 'package:flutter/material.dart';

import '../core/storage/token_storage.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';

class AppointmentRequestsScreen extends StatefulWidget {
  const AppointmentRequestsScreen({super.key});

  @override
  State<AppointmentRequestsScreen> createState() =>
      _AppointmentRequestsScreenState();
}

class _AppointmentRequestsScreenState
    extends State<AppointmentRequestsScreen> {

  final service = AppointmentService();

  List<Appointment> appointments = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    final doctorId = await TokenStorage.getUserId();

    if (doctorId == null) return;

    appointments =
    await service.getDoctorAppointments(doctorId);

    setState(() {
      loading = false;
    });
  }

  Future<void> update(
      int id,
      String status,
      ) async {

    await service.updateStatus(id, status);

    await loadAppointments();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment Requests"),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (_, index) {

          final appointment =
          appointments[index];

          return Card(
            margin:
            const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                appointment.reason,
              ),
              subtitle: Text(
                appointment.appointmentDate,
              ),
              trailing: Row(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      update(
                        appointment.id!,
                        "Approved",
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      update(
                        appointment.id!,
                        "Rejected",
                      );
                    },
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