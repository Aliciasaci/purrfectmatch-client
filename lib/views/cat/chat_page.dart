import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String userId;

  const ChatPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat avec $userId'),
      ),
      body: Center(
        child: Text('Page de chat avec l\'utilisateur $userId'),
      ),
    );
  }
}