class MedicalDocument {
  final int? id;
  final String title;
  final String fileName;
  final String filePath;

  MedicalDocument({
    this.id,
    required this.title,
    required this.fileName,
    required this.filePath,
  });

  factory MedicalDocument.fromJson(Map<String, dynamic> json) {
    return MedicalDocument(
      id: json["id"],
      title: json["title"] ?? "",
      fileName: json["file_name"] ?? "",
      filePath: json["file_path"] ?? "",
    );
  }
}