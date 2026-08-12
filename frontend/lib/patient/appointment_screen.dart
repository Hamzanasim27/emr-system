import 'package:flutter/material.dart';

import '../core/storage/token_storage.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';
import '../models/doctor_availability.dart';
import '../services/appointment_service.dart';
import '../services/doctor_availability_service.dart';
import '../services/doctor_service.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() =>
      _AppointmentScreenState();
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
  bool booking = false;

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      final loadedDoctors = await doctorService.getDoctors();

      if (!mounted) return;

      doctors = loadedDoctors;

      if (doctors.isNotEmpty) {
        selectedDoctor = doctors.first;

        await loadAvailability(
          selectedDoctor!.id,
        );
      }

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
          content: Text("Failed to load doctors: $e"),
        ),
      );
    }
  }

  Future<void> loadAvailability(int doctorId) async {
    try {
      final loadedSlots =
      await availabilityService.getAvailability(
        doctorId,
      );

      if (!mounted) return;

      setState(() {
        slots = loadedSlots;
        selectedSlot =
        slots.isNotEmpty ? slots.first : null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        slots = [];
        selectedSlot = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load availability: $e"),
        ),
      );
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (!mounted) return;

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> bookAppointment() async {
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

    final patientId = await TokenStorage.getPatientId();

    if (!mounted) return;

    if (patientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Patient not found"),
        ),
      );
      return;
    }

    final parts = selectedSlot!.startTime.split(":");

    if (parts.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid appointment time"),
        ),
      );
      return;
    }

    final appointmentDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    setState(() {
      booking = true;
    });

    try {
      await appointmentService.bookAppointment(
        Appointment(
          patientId: patientId,
          doctorId: selectedDoctor!.id,
          appointmentDate:
          appointmentDate.toIso8601String(),
          reason: reasonController.text.trim(),
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Appointment booked successfully"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        booking = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to book appointment: $e"),
        ),
      );
    }
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<Doctor>(
                initialValue: selectedDoctor,
                decoration: const InputDecoration(
                  labelText: "Select Doctor",
                  border: OutlineInputBorder(),
                ),
                items: doctors.map((doctor) {
                  return DropdownMenuItem<Doctor>(
                    value: doctor,
                    child: Text(doctor.fullName),
                  );
                }).toList(),
                onChanged: booking
                    ? null
                    : (doctor) async {
                  if (doctor == null) return;

                  setState(() {
                    selectedDoctor = doctor;
                    slots = [];
                    selectedSlot = null;
                  });

                  await loadAvailability(doctor.id);
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: reasonController,
                maxLines: 3,
                enabled: !booking,
                decoration: const InputDecoration(
                  labelText: "Reason",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<DoctorAvailability>(
                initialValue: selectedSlot,
                decoration: const InputDecoration(
                  labelText: "Available Slot",
                  border: OutlineInputBorder(),
                ),
                items: slots.map((slot) {
                  return DropdownMenuItem<
                      DoctorAvailability>(
                    value: slot,
                    child: Text(
                      "${slot.dayOfWeek}   "
                          "${slot.startTime} - "
                          "${slot.endTime}",
                    ),
                  );
                }).toList(),
                onChanged: booking
                    ? null
                    : (value) {
                  setState(() {
                    selectedSlot = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              ListTile(
                enabled: !booking,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                title: Text(
                  selectedDate == null
                      ? "Select Appointment Date"
                      : "${selectedDate!.day}-"
                      "${selectedDate!.month}-"
                      "${selectedDate!.year}",
                ),
                trailing: const Icon(
                  Icons.calendar_today,
                ),
                onTap: booking ? null : pickDate,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: booking
                      ? null
                      : bookAppointment,
                  child: booking
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Book Appointment"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}