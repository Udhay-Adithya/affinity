import 'package:affinity/features/event/presentation/widgets/chat_bubble.dart';
import 'package:affinity/features/event/presentation/widgets/message_input.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> _messages = [];

  void _handleSendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': message});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[_messages.length - 1 - index];
                return ChatBubble(
                  message: msg['message']!,
                  isMe: msg['sender'] == 'user',
                );
              },
            ),
          ),
          MessageInput(onSend: _handleSendMessage),
        ],
      ),
    );
  }
}
