import 'package:flutter/material.dart';

import '../core/storage/token_storage.dart';
import '../models/clinical_note.dart';
import '../services/clinical_note_service.dart';

class ClinicalNoteScreen extends StatefulWidget {
  final int patientId;

  const ClinicalNoteScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<ClinicalNoteScreen> createState() =>
      _ClinicalNoteScreenState();
}

class _ClinicalNoteScreenState
    extends State<ClinicalNoteScreen> {

  final service = ClinicalNoteService();

  final controller = TextEditingController();

  List<ClinicalNote> notes = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    notes = await service.getNotes(widget.patientId);

    setState(() {
      loading = false;
    });
  }

  Future<void> saveNote() async {
    final doctorId = await TokenStorage.getUserId();

    if (doctorId == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Doctor ID not found"),
        ),
      );
      return;
    }

    await service.addNote(
      ClinicalNote(
        patientId: widget.patientId,
        doctorId: doctorId, // <-- already an int
        note: controller.text,
      ),
    );

    controller.clear();

    await loadNotes();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Clinical Notes"),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Clinical Note",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: saveNote,
            child: const Text("Save Note"),
          ),

          const Divider(),

          Expanded(
            child: loading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) {

                final note = notes[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(note.note),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await service.deleteNote(note.id!);
                        loadNotes();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}