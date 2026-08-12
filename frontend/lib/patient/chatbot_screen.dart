import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/chatbot_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ChatbotService service = ChatbotService();

  final TextEditingController controller = TextEditingController();

  final List<ChatMessage> messages = [];

  bool loading = false;

  Future<void> send() async {
    if (controller.text.trim().isEmpty) return;

    String text = controller.text.trim();

    controller.clear();

    setState(() {
      messages.add(
        ChatMessage(
          message: text,
          isUser: true,
        ),
      );

      loading = true;
    });

    String reply = await service.ask(text);

    setState(() {
      loading = false;

      messages.add(
        ChatMessage(
          message: reply,
          isUser: false,
        ),
      );
    });
  }

  Widget bubble(ChatMessage msg) {
    return Align(
      alignment:
      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(
          maxWidth: 300,
        ),
        decoration: BoxDecoration(
          color: msg.isUser
              ? Colors.blue
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg.message,
          style: TextStyle(
            color: msg.isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Health Assistant"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) {
                return bubble(messages[index]);
              },
            ),
          ),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Ask something...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => send(),
                  ),
                ),
              ),

              IconButton(
                onPressed: send,
                icon: const Icon(Icons.send),
              )
            ],
          ),
        ],
      ),
    );
  }
}