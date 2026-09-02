import 'package:flutter/material.dart';

import '../services/soap_service.dart';

class SoapNoteScreen extends StatefulWidget {
  final int noteId;

  const SoapNoteScreen({
    super.key,
    required this.noteId,
  });

  @override
  State<SoapNoteScreen> createState() => _SoapNoteScreenState();
}

class _SoapNoteScreenState extends State<SoapNoteScreen> {
  final service = SoapService();

  Map<String, dynamic>? soapData;

  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadSoapNote();
  }

  Future<void> loadSoapNote() async {
    try {
      final data = await service.getSoapNote(widget.noteId);

      if (!mounted) return;

      setState(() {
        soapData = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        error = "Unable to load SOAP note.";
      });
    }
  }

  Map<String, String> parseSoapNote(String note) {
    final sections = <String, String>{
      "SUBJECTIVE": "",
      "OBJECTIVE": "",
      "ASSESSMENT": "",
      "PLAN": "",
    };

    final regex = RegExp(
      r'(SUBJECTIVE|OBJECTIVE|ASSESSMENT|PLAN):\s*(.*?)(?=\n\s*(?:SUBJECTIVE|OBJECTIVE|ASSESSMENT|PLAN):|$)',
      caseSensitive: false,
      dotAll: true,
    );

    for (final match in regex.allMatches(note)) {
      final title = match.group(1)!.toUpperCase();
      final content = match.group(2)!.trim();

      sections[title] = content;
    }

    return sections;
  }

  Widget soapSection(
      String title,
      String content,
      IconData icon,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content.isEmpty ? "No information available." : content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SOAP Note"),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : error != null
          ? Center(
        child: Text(error!),
      )
          : soapData == null
          ? const Center(
        child: Text("SOAP note not found."),
      )
          : buildSoapContent(),
    );
  }

  Widget buildSoapContent() {
    final note = soapData!["soap_note"] ?? "";

    final sections = parseSoapNote(note);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Medical SOAP Note",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Clinical documentation from your consultation",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          soapSection(
            "Subjective",
            sections["SUBJECTIVE"] ?? "",
            Icons.person,
          ),

          soapSection(
            "Objective",
            sections["OBJECTIVE"] ?? "",
            Icons.monitor_heart,
          ),

          soapSection(
            "Assessment",
            sections["ASSESSMENT"] ?? "",
            Icons.medical_information,
          ),

          soapSection(
            "Plan",
            sections["PLAN"] ?? "",
            Icons.assignment,
          ),

          const SizedBox(height: 10),

          const Text(
            "This SOAP note is part of your medical record.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}