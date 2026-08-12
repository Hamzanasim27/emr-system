import 'package:flutter/material.dart';

import 'appointment_requests_screen.dart';
import 'authorized_patients_screen.dart';
import 'availability_screen.dart';
import '../auth/login_screen.dart';
import '../services/auth_service.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  void _openPatients(
      BuildContext context,
      String action,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AuthorizedPatientsScreen(
          action: action,
        ),
      ),
    );
  }

  void _openAppointmentRequests(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AppointmentRequestsScreen(),
      ),
    );
  }

  void _openAvailability(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AvailabilityScreen(),
      ),
    );
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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          if (isMobile) {
            return _MobileDashboard(
              onPatientsTap: () => _openPatients(
                context,
                "consultation",
              ),
              onConsultationTap: () => _openPatients(
                context,
                "consultation",
              ),
              onPrescriptionTap: () => _openPatients(
                context,
                "prescription",
              ),
              onDocumentsTap: () => _openPatients(
                context,
                "documents",
              ),
              onNotesTap: () => _openPatients(
                context,
                "notes",
              ),
              onAppointmentTap: () =>
                  _openAppointmentRequests(context),
              onAvailabilityTap: () => _openAvailability(context),
              onLogout: () => _logout(context),
            );
          }

          return Row(
            children: [
              _Sidebar(
                onDashboardTap: () {},
                onPatientsTap: () => _openPatients(
                  context,
                  "consultation",
                ),
                onConsultationTap: () => _openPatients(
                  context,
                  "consultation",
                ),
                onDocumentsTap: () => _openPatients(
                  context,
                  "documents",
                ),
                onAiTap: () {},
                onSettingsTap: () {},
                onLogout: () => _logout(context),
              ),
              Expanded(
                child: Column(
                  children: [
                    const _TopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const _WelcomeSection(),
                            const SizedBox(height: 24),
                            const _StatisticsRow(),
                            const SizedBox(height: 28),
                            _DashboardSection(
                              onPatientsTap: () => _openPatients(
                                context,
                                "consultation",
                              ),
                              onConsultationTap: () =>
                                  _openPatients(
                                    context,
                                    "consultation",
                                  ),
                              onDocumentsTap: () => _openPatients(
                                context,
                                "documents",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final VoidCallback onDashboardTap;
  final VoidCallback onPatientsTap;
  final VoidCallback onConsultationTap;
  final VoidCallback onDocumentsTap;
  final VoidCallback onAiTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onLogout;

  const _Sidebar({
    required this.onDashboardTap,
    required this.onPatientsTap,
    required this.onConsultationTap,
    required this.onDocumentsTap,
    required this.onAiTap,
    required this.onSettingsTap,
    required this.onLogout,
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
          _SidebarItem(
            icon: Icons.dashboard_rounded,
            title: "Dashboard",
            selected: true,
            onTap: onDashboardTap,
          ),
          _SidebarItem(
            icon: Icons.people_alt_rounded,
            title: "Patients",
            onTap: onPatientsTap,
          ),
          _SidebarItem(
            icon: Icons.medical_information_rounded,
            title: "Consultations",
            onTap: onConsultationTap,
          ),
          _SidebarItem(
            icon: Icons.folder_copy_rounded,
            title: "Documents",
            onTap: onDocumentsTap,
          ),
          _SidebarItem(
            icon: Icons.chat_bubble_rounded,
            title: "AI Assistant",
            onTap: onAiTap,
          ),
          const Spacer(),
          _SidebarItem(
            icon: Icons.settings_rounded,
            title: "Settings",
            onTap: onSettingsTap,
          ),
          _SidebarItem(
            icon: Icons.logout_rounded,
            title: "Logout",
            onTap: onLogout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback? onTap;

  const _SidebarItem({
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
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
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

class _TopBar extends StatelessWidget {
  const _TopBar();

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
            "Doctor Dashboard",
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
            "Doctor",
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

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good evening, Doctor 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Here is an overview of your medical practice today.",
                  style: TextStyle(
                    color: Colors.white70,
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
              color: Colors.white24,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsRow extends StatelessWidget {
  const _StatisticsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            title: "Patients",
            value: "24",
            subtitle: "Authorized patients",
            icon: Icons.people_alt_rounded,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: "Consultations",
            value: "12",
            subtitle: "This month",
            icon: Icons.medical_information_rounded,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: "Documents",
            value: "38",
            subtitle: "Medical records",
            icon: Icons.folder_copy_rounded,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: "AI Assistant",
            value: "8",
            subtitle: "Recent analyses",
            icon: Icons.auto_awesome_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _StatCard({
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

class _DashboardSection extends StatelessWidget {
  final VoidCallback onPatientsTap;
  final VoidCallback onConsultationTap;
  final VoidCallback onDocumentsTap;

  const _DashboardSection({
    required this.onPatientsTap,
    required this.onConsultationTap,
    required this.onDocumentsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Access",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF172033),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _QuickCard(
                icon: Icons.people_alt_rounded,
                title: "Authorized Patients",
                description: "View and manage your patients",
                onTap: onPatientsTap,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _QuickCard(
                icon: Icons.medical_information_rounded,
                title: "Consultation Records",
                description: "Review patient consultations",
                onTap: onConsultationTap,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _QuickCard(
                icon: Icons.folder_copy_rounded,
                title: "Medical Documents",
                description: "Access uploaded documents",
                onTap: onDocumentsTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const _QuickCard({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 135,
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
              blurRadius: 8,
              offset: Offset(0, 3),
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
                icon,
                size: 22,
                color: const Color(0xFF1976D2),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172033),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFF98A2B3),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileDashboard extends StatelessWidget {
  final VoidCallback onPatientsTap;
  final VoidCallback onConsultationTap;
  final VoidCallback onPrescriptionTap;
  final VoidCallback onDocumentsTap;
  final VoidCallback onNotesTap;
  final VoidCallback onAppointmentTap;
  final VoidCallback onAvailabilityTap;
  final VoidCallback onLogout;

  const _MobileDashboard({
    required this.onPatientsTap,
    required this.onConsultationTap,
    required this.onPrescriptionTap,
    required this.onDocumentsTap,
    required this.onNotesTap,
    required this.onAppointmentTap,
    required this.onAvailabilityTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172033),
        title: const Text(
          "EMR Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: _Sidebar(
          onDashboardTap: () => Navigator.pop(context),
          onPatientsTap: onPatientsTap,
          onConsultationTap: onConsultationTap,
          onDocumentsTap: onDocumentsTap,
          onAiTap: () {},
          onSettingsTap: () {},
          onLogout: onLogout,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _WelcomeSection(),
            const SizedBox(height: 20),
            const _MobileStat(
              title: "Authorized Patients",
              value: "24",
              icon: Icons.people_alt_rounded,
            ),
            const SizedBox(height: 10),
            const _MobileStat(
              title: "Consultations",
              value: "12",
              icon: Icons.medical_information_rounded,
            ),
            const SizedBox(height: 10),
            const _MobileStat(
              title: "Documents",
              value: "38",
              icon: Icons.folder_copy_rounded,
            ),
            const SizedBox(height: 25),
            const Text(
              "Quick Access",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _QuickCard(
              icon: Icons.people_alt_rounded,
              title: "Authorized Patients",
              description: "View and manage your patients",
              onTap: onPatientsTap,
            ),
            const SizedBox(height: 12),
            _QuickCard(
              icon: Icons.medical_information_rounded,
              title: "Consultation Records",
              description: "Review patient consultations",
              onTap: onConsultationTap,
            ),
            const SizedBox(height: 12),
            _QuickCard(
              icon: Icons.receipt_long_rounded,
              title: "Prescriptions",
              description: "Manage patient prescriptions",
              onTap: onPrescriptionTap,
            ),
            const SizedBox(height: 12),
            _QuickCard(
              icon: Icons.folder_copy_rounded,
              title: "Medical Documents",
              description: "Access uploaded documents",
              onTap: onDocumentsTap,
            ),
            const SizedBox(height: 12),
            _QuickCard(
              icon: Icons.note_alt_rounded,
              title: "Clinical Notes",
              description: "Manage clinical notes",
              onTap: onNotesTap,
            ),
            const SizedBox(height: 12),
            _QuickCard(
              icon: Icons.calendar_today_rounded,
              title: "Appointment Requests",
              description: "Review appointment requests",
              onTap: onAppointmentTap,
            ),
            const SizedBox(height: 12),
            _QuickCard(
              icon: Icons.schedule_rounded,
              title: "Availability",
              description: "Manage your availability",
              onTap: onAvailabilityTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MobileStat({
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
              color: const Color(0xFF1976D2),
              size: 20,
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