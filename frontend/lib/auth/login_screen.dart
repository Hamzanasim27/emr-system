import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../core/storage/token_storage.dart';
import '../doctor/doctor_dashboard.dart';
import '../patient/patient_dashboard.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  final auth = AuthService();

  bool loading = false;

  Future<void> login() async {
    setState(() {
      loading = true;
    });

    try {
      await auth.login(
        email.text,
        password.text,
      );

      final role = await TokenStorage.getRole();

      if (!mounted) return;

      if (role == "doctor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DoctorDashboard(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PatientDashboard(),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Widget field(
      String label,
      TextEditingController controller, {
        bool obscure = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EMR Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            field("Email", email),
            field("Password", password, obscure: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : login,
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}