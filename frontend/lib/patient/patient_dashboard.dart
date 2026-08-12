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

  void _openScreen(BuildContext context, String title) {
    Widget? screen;

    switch (title) {
      case "Consultations":
        screen = const ConsultationScreen();
        break;
      case "Prescriptions":
        screen = const PrescriptionScreen();
        break;
      case "Medical Documents":
        screen = const DocumentScreen();
        break;
      case "Book Appointment":
        screen = const AppointmentScreen();
        break;
      case "My Appointments":
        screen = const MyAppointmentsScreen();
        break;
      case "Medical History":
        screen = const MedicalHistoryScreen();
        break;
      case "AI Health Assistant":
        screen = const ChatbotScreen();
        break;
      case "Edit Profile":
        screen = const EditProfileScreen();
        break;
    }

    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => screen!,
        ),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 750;

        if (isMobile) {
          return _MobilePatientDashboard(
            openScreen: _openScreen,
            logout: _logout,
          );
        }

        return _DesktopPatientDashboard(
          openScreen: _openScreen,
          logout: _logout,
        );
      },
    );
  }
}

class _DesktopPatientDashboard extends StatelessWidget {
  final void Function(BuildContext, String) openScreen;
  final Future<void> Function(BuildContext) logout;

  const _DesktopPatientDashboard({
    required this.openScreen,
    required this.logout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Row(
        children: [
          _PatientSidebar(
            openScreen: openScreen,
            logout: logout,
          ),
          Expanded(
            child: Column(
              children: [
                const _PatientTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _PatientWelcome(),
                        const SizedBox(height: 24),
                        const _PatientStats(),
                        const SizedBox(height: 28),
                        const Text(
                          "Quick Access",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF172033),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _QuickAccessGrid(
                          openScreen: openScreen,
                        ),
                        const SizedBox(height: 28),
                        const _HealthOverview(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientSidebar extends StatelessWidget {
  final void Function(BuildContext, String) openScreen;
  final Future<void> Function(BuildContext) logout;

  const _PatientSidebar({
    required this.openScreen,
    required this.logout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "EMR System",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172033),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          const _PatientSidebarItem(
            icon: Icons.dashboard_rounded,
            title: "Dashboard",
            selected: true,
          ),
          _PatientSidebarItem(
            icon: Icons.medical_information_rounded,
            title: "Consultations",
            onTap: () => openScreen(context, "Consultations"),
          ),
          _PatientSidebarItem(
            icon: Icons.receipt_long_rounded,
            title: "Prescriptions",
            onTap: () => openScreen(context, "Prescriptions"),
          ),
          _PatientSidebarItem(
            icon: Icons.folder_copy_rounded,
            title: "Medical Documents",
            onTap: () => openScreen(context, "Medical Documents"),
          ),
          _PatientSidebarItem(
            icon: Icons.calendar_month_rounded,
            title: "Appointments",
            onTap: () => openScreen(context, "My Appointments"),
          ),
          _PatientSidebarItem(
            icon: Icons.history_rounded,
            title: "Medical History",
            onTap: () => openScreen(context, "Medical History"),
          ),
          _PatientSidebarItem(
            icon: Icons.auto_awesome_rounded,
            title: "AI Assistant",
            onTap: () => openScreen(
              context,
              "AI Health Assistant",
            ),
          ),
          const Spacer(),
          _PatientSidebarItem(
            icon: Icons.person_outline_rounded,
            title: "My Profile",
            onTap: () => openScreen(context, "Edit Profile"),
          ),
          _PatientSidebarItem(
            icon: Icons.logout_rounded,
            title: "Logout",
            onTap: () => logout(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _PatientSidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback? onTap;

  const _PatientSidebarItem({
    required this.icon,
    required this.title,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 3,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFE8F1FC)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? const Color(0xFF1976D2)
                    : const Color(0xFF667085),
              ),
              const SizedBox(width: 13),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: selected
                      ? const Color(0xFF1976D2)
                      : const Color(0xFF475467),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatientTopBar extends StatelessWidget {
  const _PatientTopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8ECF2),
          ),
        ),
      ),
      child: Row(
        children: [
          const Text(
            "Patient Dashboard",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF172033),
            ),
          ),
          const Spacer(),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 21,
              color: Color(0xFF475467),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FC),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 20,
              color: Color(0xFF1976D2),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "Patient",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF344054),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientWelcome extends StatelessWidget {
  const _PatientWelcome();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1976D2),
            Color(0xFF3B82F6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome back 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Manage your health records, appointments and medical information.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.health_and_safety_rounded,
              color: Colors.white,
              size: 31,
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientStats extends StatelessWidget {
  const _PatientStats();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _PatientStatCard(
            title: "Appointments",
            value: "0",
            subtitle: "Upcoming",
            icon: Icons.calendar_today_rounded,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _PatientStatCard(
            title: "Consultations",
            value: "0",
            subtitle: "Medical consultations",
            icon: Icons.medical_information_rounded,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _PatientStatCard(
            title: "Documents",
            value: "0",
            subtitle: "Medical documents",
            icon: Icons.folder_copy_rounded,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _PatientStatCard(
            title: "Prescriptions",
            value: "0",
            subtitle: "Active prescriptions",
            icon: Icons.receipt_long_rounded,
          ),
        ),
      ],
    );
  }
}

class _PatientStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _PatientStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE8ECF2),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FC),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              size: 21,
              color: const Color(0xFF1976D2),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF667085),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172033),
                  ),
                ),
                Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF98A2B3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  final void Function(BuildContext, String) openScreen;

  const _QuickAccessGrid({
    required this.openScreen,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "title": "Consultations",
        "description": "View your medical consultations",
        "icon": Icons.medical_information_rounded,
      },
      {
        "title": "Prescriptions",
        "description": "View your prescriptions",
        "icon": Icons.receipt_long_rounded,
      },
      {
        "title": "Medical Documents",
        "description": "Access your health documents",
        "icon": Icons.folder_copy_rounded,
      },
      {
        "title": "Book Appointment",
        "description": "Schedule a doctor appointment",
        "icon": Icons.calendar_month_rounded,
      },
      {
        "title": "My Appointments",
        "description": "View upcoming appointments",
        "icon": Icons.event_note_rounded,
      },
      {
        "title": "Medical History",
        "description": "Review your health history",
        "icon": Icons.history_rounded,
      },
      {
        "title": "AI Health Assistant",
        "description": "Get help from your AI assistant",
        "icon": Icons.auto_awesome_rounded,
      },
      {
        "title": "Edit Profile",
        "description": "Update your personal information",
        "icon": Icons.person_outline_rounded,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 135,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return _PatientQuickCard(
          title: item["title"] as String,
          description: item["description"] as String,
          icon: item["icon"] as IconData,
          onTap: () {
            openScreen(
              context,
              item["title"] as String,
            );
          },
        );
      },
    );
  }
}

class _PatientQuickCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _PatientQuickCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_PatientQuickCard> createState() =>
      _PatientQuickCardState();
}

class _PatientQuickCardState
    extends State<_PatientQuickCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => hovering = true);
      },
      onExit: (_) {
        setState(() => hovering = false);
      },
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hovering
                  ? const Color(0xFF1976D2)
                  : const Color(0xFFE8ECF2),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x08000000),
                blurRadius: hovering ? 16 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FC),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  widget.icon,
                  size: 22,
                  color: const Color(0xFF1976D2),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: Color(0xFF98A2B3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthOverview extends StatelessWidget {
  const _HealthOverview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE8ECF2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7EF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.health_and_safety_rounded,
              color: Color(0xFF16A34A),
              size: 23,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your health records are organized",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172033),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Access your consultations, prescriptions, documents and appointments from the menu.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobilePatientDashboard extends StatelessWidget {
  final void Function(BuildContext, String) openScreen;
  final Future<void> Function(BuildContext) logout;

  const _MobilePatientDashboard({
    required this.openScreen,
    required this.logout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172033),
        elevation: 0,
        title: const Text(
          "EMR System",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: _PatientSidebar(
          openScreen: openScreen,
          logout: logout,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PatientWelcome(),
            const SizedBox(height: 20),
            const _PatientMobileStat(
              title: "Appointments",
              value: "0",
              icon: Icons.calendar_today_rounded,
            ),
            const SizedBox(height: 10),
            const _PatientMobileStat(
              title: "Consultations",
              value: "0",
              icon: Icons.medical_information_rounded,
            ),
            const SizedBox(height: 10),
            const _PatientMobileStat(
              title: "Documents",
              value: "0",
              icon: Icons.folder_copy_rounded,
            ),
            const SizedBox(height: 24),
            const Text(
              "Quick Access",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 12),
            _PatientMobileCard(
              title: "Consultations",
              description: "View your medical consultations",
              icon: Icons.medical_information_rounded,
              onTap: () => openScreen(
                context,
                "Consultations",
              ),
            ),
            const SizedBox(height: 10),
            _PatientMobileCard(
              title: "Prescriptions",
              description: "View your prescriptions",
              icon: Icons.receipt_long_rounded,
              onTap: () => openScreen(
                context,
                "Prescriptions",
              ),
            ),
            const SizedBox(height: 10),
            _PatientMobileCard(
              title: "Medical Documents",
              description: "Access your health documents",
              icon: Icons.folder_copy_rounded,
              onTap: () => openScreen(
                context,
                "Medical Documents",
              ),
            ),
            const SizedBox(height: 10),
            _PatientMobileCard(
              title: "Book Appointment",
              description: "Schedule a doctor appointment",
              icon: Icons.calendar_month_rounded,
              onTap: () => openScreen(
                context,
                "Book Appointment",
              ),
            ),
            const SizedBox(height: 10),
            _PatientMobileCard(
              title: "AI Health Assistant",
              description: "Talk to your AI health assistant",
              icon: Icons.auto_awesome_rounded,
              onTap: () => openScreen(
                context,
                "AI Health Assistant",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PatientMobileStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _PatientMobileStat({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFE8ECF2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF1976D2),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF344054),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1976D2),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientMobileCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _PatientMobileCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFFE8ECF2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 21,
                color: const Color(0xFF1976D2),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172033),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: Color(0xFF98A2B3),
            ),
          ],
        ),
      ),
    );
  }
}