import 'package:flutter/material.dart';

import 'appointment_screen.dart';
import 'my_appointments_screen.dart';
import 'consultation_screen.dart';
import 'prescription_screen.dart';
import 'upload_document_screen.dart';
import 'edit_profile_screen.dart';
import 'medical_history_screen.dart';
import 'chatbot_screen.dart';
import '../services/auth_service.dart';
import '../auth/login_screen.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "title": "Consultations",
        "icon": Icons.medical_services,
      },
      {
        "title": "Prescriptions",
        "icon": Icons.receipt_long,
      },
      {
        "title": "Medical Documents",
        "icon": Icons.folder,
      },
      {
        "title": "Book Appointment",
        "icon": Icons.calendar_month,
      },
      {
        "title": "My Appointments",
        "icon": Icons.event_note,
      },
      {
        "title": "Medical History",
        "icon": Icons.history,
      },
      {
        "title": "AI Health Assistant",
        "icon": Icons.smart_toy,
      },
      {
        "title": "Edit Profile",
        "icon": Icons.person,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (_, index) {
          final item = items[index];

          return Card(
            elevation: 5,
            child: InkWell(
              onTap: () {
                switch (item["title"]) {
                  case "Consultations":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConsultationScreen(),
                      ),
                    );
                    break;

                  case "Prescriptions":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrescriptionScreen(),
                      ),
                    );
                    break;

                  case "Medical Documents":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DocumentScreen(),
                      ),
                    );
                    break;

                  case "Book Appointment":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AppointmentScreen(),
                      ),
                    );
                    break;

                  case "My Appointments":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const MyAppointmentsScreen(),
                      ),
                    );
                    break;

                  case "Medical History":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MedicalHistoryScreen(),
                      ),
                    );
                    break;

                  case "AI Health Assistant":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChatbotScreen(),
                      ),
                    );
                    break;

                  case "Edit Profile":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                    break;
                }
              },
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    item["icon"] as IconData,
                    size: 50,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item["title"] as String,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}