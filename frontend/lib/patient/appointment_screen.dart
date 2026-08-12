import 'package:flutter/material.dart';

import '../core/storage/token_storage.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';
import '../services/appointment_service.dart';
import '../services/doctor_service.dart';
import '../models/doctor_availability.dart';
import '../services/doctor_availability_service.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final appointmentService = AppointmentService();
  final doctorService = DoctorService();
  final availabilityService = DoctorAvailabilityService();

  final reasonController = TextEditingController();

  List<Doctor> doctors = [];
  Doctor? selectedDoctor;

  List<DoctorAvailability> slots = [];
  DoctorAvailability? selectedSlot;

  DateTime? selectedDate;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    doctors = await doctorService.getDoctors();

    if (doctors.isNotEmpty) {
      selectedDoctor = doctors.first;
      await loadAvailability(selectedDoctor!.id);
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> loadAvailability(int doctorId) async {
    slots = await availabilityService.getAvailability(
      doctorId,
    );

    if (slots.isNotEmpty) {
      selectedSlot = slots.first;
    } else {
      selectedSlot = null;
    }

    setState(() {});
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> bookAppointment() async {
    final patientId = await TokenStorage.getPatientId();

    if (patientId == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Patient not found"),
        ),
      );
      return;
    }

    if (selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a doctor"),
        ),
      );
      return;
    }

    if (selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select appointment slot"),
        ),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a date"),
        ),
      );
      return;
    }

    final parts = selectedSlot!.startTime.split(":");

    final appointmentDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    await appointmentService.bookAppointment(
      Appointment(
        patientId: patientId,
        doctorId: selectedDoctor!.id,
        appointmentDate: appointmentDate.toIso8601String(),
        reason: reasonController.text,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Appointment booked successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            DropdownButtonFormField<Doctor>(
              value: selectedDoctor,
              decoration: const InputDecoration(
                labelText: "Select Doctor",
                border: OutlineInputBorder(),
              ),
              items: doctors.map((doctor) {
                return DropdownMenuItem(
                  value: doctor,
                  child: Text(doctor.fullName),
                );
              }).toList(),
              onChanged: (doctor) async {
                if (doctor == null) return;

                selectedDoctor = doctor;

                await loadAvailability(doctor.id);
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Reason",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<DoctorAvailability>(
              value: selectedSlot,
              decoration: const InputDecoration(
                labelText: "Available Slot",
                border: OutlineInputBorder(),
              ),
              items: slots.map((slot) {
                return DropdownMenuItem(
                  value: slot,
                  child: Text(
                    "${slot.dayOfWeek}   ${slot.startTime} - ${slot.endTime}",
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSlot = value;
                });
              },
            ),
            const SizedBox(height: 15),
            ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              title: Text(
                selectedDate == null
                    ? "Select Appointment Date"
                    : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: pickDate,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: bookAppointment,
                child: const Text("Book Appointment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}