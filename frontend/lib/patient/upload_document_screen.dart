import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/document.dart';
import '../../services/document_service.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final service = DocumentService();

  List<MedicalDocument> documents = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    documents = await service.getDocuments();
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
                final uri = Uri.parse(
                  "http://10.0.2.2:8000/uploads/documents/report.pdf",
                );

                final success = await launchUrl(
                  uri,
                  mode: LaunchMode.inAppBrowserView,
                );

                print("Opened: $success");
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload),
        onPressed: () async {
          await service.upload();
          load();
        },
      ),
    );
  }
}