import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String shopName;
  final String shopCity;

  const ChatScreen({super.key, required this.shopName, required this.shopCity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$shopName')),
      body: Center(
        child: Text(
          'Chats Page',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
