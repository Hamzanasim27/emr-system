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
        "description": "View your consultation records",
        "icon": Icons.medical_services_rounded,
      },
      {
        "title": "Prescriptions",
        "description": "View your prescribed medicines",
        "icon": Icons.receipt_long_rounded,
      },
      {
        "title": "Medical Documents",
        "description": "Access your medical documents",
        "icon": Icons.folder_copy_rounded,
      },
      {
        "title": "Book Appointment",
        "description": "Schedule an appointment",
        "icon": Icons.calendar_month_rounded,
      },
      {
        "title": "My Appointments",
        "description": "View your upcoming appointments",
        "icon": Icons.event_note_rounded,
      },
      {
        "title": "Medical History",
        "description": "Review your medical history",
        "icon": Icons.history_rounded,
      },
      {
        "title": "AI Health Assistant",
        "description": "Get help from your AI assistant",
        "icon": Icons.smart_toy_rounded,
      },
      {
        "title": "Edit Profile",
        "description": "Update your personal information",
        "icon": Icons.person_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,

        title: const Text(
          "Patient Dashboard",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF172033),
          ),
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.logout_rounded,
                size: 20,
                color: Color(0xFF475467),
              ),
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
          ),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          // Desktop / Web
          if (constraints.maxWidth >= 900) {
            return _DesktopPatientDashboard(
              items: items,
            );
          }

          // Tablet
          if (constraints.maxWidth >= 600) {
            return _TabletPatientDashboard(
              items: items,
            );
          }

          // Mobile
          return _MobilePatientDashboard(
            items: items,
          );
        },
      ),
    );
  }
}
class _DesktopPatientDashboard extends StatelessWidget {
  final List<Map<String, Object>> items;

  const _DesktopPatientDashboard({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1976D2),
                      Color(0xFF3B82F6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back 👋",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Manage your health records and appointments.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _WelcomeIcon(),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              const Text(
                "Quick Access",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 12),

              // Compact cards
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 94,
                ),
                itemBuilder: (context, index) {
                  return _PatientQuickCard(
                    title: items[index]["title"] as String,
                    description:
                    items[index]["description"] as String,
                    icon: items[index]["icon"] as IconData,
                    onTap: () {
                      _openPatientScreen(
                        context,
                        items[index]["title"] as String,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _TabletPatientDashboard extends StatelessWidget {
  final List<Map<String, Object>> items;

  const _TabletPatientDashboard({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome back 👋",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Manage your health records and appointments.",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF667085),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            "Quick Access",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 94,
            ),
            itemBuilder: (context, index) {
              return _PatientQuickCard(
                title: items[index]["title"] as String,
                description:
                items[index]["description"] as String,
                icon: items[index]["icon"] as IconData,
                onTap: () {
                  _openPatientScreen(
                    context,
                    items[index]["title"] as String,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
class _MobilePatientDashboard extends StatelessWidget {
  final List<Map<String, Object>> items;

  const _MobilePatientDashboard({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1976D2),
                Color(0xFF3B82F6),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Manage your health records and appointments.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        const Text(
          "Quick Access",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF172033),
          ),
        ),

        const SizedBox(height: 12),

        ...items.map(
              (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PatientQuickCard(
              title: item["title"] as String,
              description: item["description"] as String,
              icon: item["icon"] as IconData,
              onTap: () {
                _openPatientScreen(
                  context,
                  item["title"] as String,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
class _PatientQuickCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;

  const _PatientQuickCard({
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: const Color(0xFFF5F9FF),
        child: Container(
          height: 94,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE6EAF0),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF1976D2),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _WelcomeIcon extends StatelessWidget {
  const _WelcomeIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Icon(
        Icons.health_and_safety_rounded,
        color: Colors.white,
        size: 27,
      ),
    );
  }
}
void _openPatientScreen(
    BuildContext context,
    String title,
    ) {
  switch (title) {
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
          builder: (_) => const MyAppointmentsScreen(),
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
}