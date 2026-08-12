import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/document.dart';
import '../services/document_service.dart';

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
    documents = await service.getPatientDocuments(
      widget.patientId,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Documents"),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (_, index) {
          final document = documents[index];

          return Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(document.title),
              subtitle: Text(document.fileName),
              trailing: const Icon(Icons.open_in_new),
              onTap: () async {
                print(document.filePath);

                String url = document.filePath;

                if (!url.startsWith("http")) {
                  url = "http://10.0.2.2:8000/${url.replaceAll("\\", "/")}";
                }

                print(url);

                final uri = Uri.parse(url);

                await launchUrl(
                  uri,
                  mode: LaunchMode.inAppBrowserView,
                );

                final success = await launchUrl(
                  uri,
                  mode: LaunchMode.inAppBrowserView,
                );

                print(success);
              },
            ),
          );
        },
      ),
    );
  }
}