import 'package:dio/dio.dart';

import '../core/api/api_client.dart';

class ChatbotService {
  Future<String> ask(String message) async {
    final response = await ApiClient.dio.post(
      "/chatbot/",
      data: {
        "message": message,
      },
    );

    return response.data["reply"];
  }
}