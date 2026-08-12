import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  String role = "patient";

  final auth = AuthService();

  bool loading = false;

  Future<void> register() async {
    setState(() {
      loading = true;
    });

    try {
      await auth.register(
        fullName: name.text,
        email: email.text,
        password: password.text,
        role: role,
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() {
      loading = false;
    });
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
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            field("Full Name", name),
            field("Email", email),
            field("Password", password, obscure: true),

            DropdownButtonFormField<String>(
              value: role,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Role",
              ),
              items: const [
                DropdownMenuItem(
                  value: "patient",
                  child: Text("Patient"),
                ),
                DropdownMenuItem(
                  value: "doctor",
                  child: Text("Doctor"),
                ),
              ],
              onChanged: (value) {
                role = value!;
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : register,
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
