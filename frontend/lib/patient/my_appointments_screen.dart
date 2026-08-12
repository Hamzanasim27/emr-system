import 'package:flutter/material.dart';

import '../core/storage/token_storage.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() =>
      _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState
    extends State<MyAppointmentsScreen> {

  final service = AppointmentService();

  List<Appointment> appointments = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    final patientId = await TokenStorage.getPatientId();

    if (patientId == null) return;

    appointments =
    await service.getPatientAppointments(patientId);

    setState(() {
      loading = false;
    });
  }

  Color statusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "Completed":
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Appointments"),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (_, index) {

          final appointment = appointments[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(appointment.reason),
              subtitle: Text(
                appointment.appointmentDate,
              ),
              trailing: Chip(
                label: Text(
                  appointment.status,
                ),
                backgroundColor: statusColor(
                  appointment.status,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}