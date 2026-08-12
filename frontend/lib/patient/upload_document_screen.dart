import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/document.dart';
import '../../services/document_service.dart';
import '../core/api/endpoints.dart';

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

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> openDocument(MedicalDocument document) async {
    String url = document.filePath.replaceAll("\\", "/");

    if (url.contains("10.0.2.2:8000")) {
      url = url.replaceFirst(
        "http://10.0.2.2:8000",
        Endpoints.baseUrl,
      );
    } else if (!url.startsWith("http")) {
      url = "${Endpoints.baseUrl}/$url";
    }

    final uri = Uri.parse(url);

    final success = await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not open the document"),
        ),
      );
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
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(document.title),
              subtitle: Text(document.fileName),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => openDocument(document),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload),
        onPressed: () async {
          await service.upload();
          await load();
        },
      ),
    );
  }
}