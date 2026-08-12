import 'package:flutter/material.dart';

import 'appointment_requests_screen.dart';
import 'authorized_patients_screen.dart';
import 'availability_screen.dart';
import '../services/auth_service.dart';
import '../auth/login_screen.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "title": "Authorized Patients",
        "icon": Icons.people,
      },
      {
        "title": "Consultation Records",
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
        "title": "Clinical Notes",
        "icon": Icons.note_alt,
      },
      {
        "title": "Appointment Requests",
        "icon": Icons.calendar_today,
      },
      {
        "title": "Availability",
        "icon": Icons.schedule,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Dashboard"),
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
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          final item = items[index];

          return Card(
            elevation: 5,
            child: InkWell(
              onTap: () {
                if (item["title"] == "Authorized Patients") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AuthorizedPatientsScreen(
                        action: "consultation",
                      ),
                    ),
                  );
                } else if (item["title"] == "Consultation Records") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AuthorizedPatientsScreen(
                        action: "consultation",
                      ),
                    ),
                  );
                } else if (item["title"] == "Prescriptions") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AuthorizedPatientsScreen(
                        action: "prescription",
                      ),
                    ),
                  );
                } else if (item["title"] == "Medical Documents") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AuthorizedPatientsScreen(
                        action: "documents",
                      ),
                    ),
                  );
                } else if (item["title"] == "Clinical Notes") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AuthorizedPatientsScreen(
                        action: "notes",
                      ),
                    ),
                  );
                } else if (item["title"] == "Appointment Requests") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AppointmentRequestsScreen(),
                    ),
                  );
                } else if (item["title"] == "Availability") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AvailabilityScreen(),
                    ),
                  );
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
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