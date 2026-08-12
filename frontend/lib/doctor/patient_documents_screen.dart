import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/document.dart';
import '../services/document_service.dart';
import '../core/api/endpoints.dart';

class DoctorDocumentScreen extends StatefulWidget {
  final int patientId;

  const DoctorDocumentScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<DoctorDocumentScreen> createState() =>
      _DoctorDocumentScreenState();
}

class _DoctorDocumentScreenState
    extends State<DoctorDocumentScreen> {
  final service = DocumentService();

  List<MedicalDocument> documents = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final result = await service.getPatientDocuments(
        widget.patientId,
      );

      if (mounted) {
        setState(() {
          documents = result;
        });
      }
    } catch (e) {
      debugPrint("Error loading documents: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not load documents"),
          ),
        );
      }
    }
  }

  String getDocumentUrl(String filePath) {
    // Convert Windows backslashes to normal URL slashes
    String url = filePath.replaceAll("\\", "/").trim();

    // If backend already returned a full Render URL,
    // use it directly.
    if (url.startsWith(Endpoints.baseUrl)) {
      return url;
    }

    // Convert old local Android emulator URL
    if (url.contains("10.0.2.2:8000")) {
      url = url.replaceFirst(
        "http://10.0.2.2:8000",
        Endpoints.baseUrl,
      );

      return url;
    }

    // If backend returned another localhost URL,
    // replace it with Render.
    if (url.contains("localhost:8000")) {
      url = url.replaceFirst(
        "http://localhost:8000",
        Endpoints.baseUrl,
      );

      return url;
    }

    // If backend returned a relative path such as:
    // /uploads/documents/report.pdf
    if (!url.startsWith("http://") &&
        !url.startsWith("https://")) {
      if (!url.startsWith("/")) {
        url = "/$url";
      }

      return "${Endpoints.baseUrl}$url";
    }

    return url;
  }

  Future<void> openDocument(MedicalDocument document) async {
    final url = getDocumentUrl(document.filePath);

    debugPrint("Opening document: $url");

    final uri = Uri.tryParse(url);

    if (uri == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid document URL"),
          ),
        );
      }
      return;
    }

    try {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not open the document"),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error opening document: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not open the document"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Documents"),
      ),
      body: documents.isEmpty
          ? const Center(
        child: Text("No medical documents found"),
      )
          : ListView.builder(
        itemCount: documents.length,
        itemBuilder: (_, index) {
          final document = documents[index];

          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.picture_as_pdf,
              ),
              title: Text(document.title),
              subtitle: Text(document.fileName),
              trailing: const Icon(
                Icons.open_in_new,
              ),
              onTap: () => openDocument(document),
            ),
          );
        },
      ),
    );
  }
}