import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String? shopName; // optional
  final String? shopCity;

  const ChatScreen({super.key, this.shopName, this.shopCity});

  @override
  Widget build(BuildContext context) {
    if (shopName == null) {
      // No shop selected → show info message
      return Scaffold(
        appBar: AppBar(title: const Text("Chat")),
        body: const Center(
          child: Text(
            "Please select a shop to start chatting!",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // Shop is provided → load chat UI
    return Scaffold(
      appBar: AppBar(title: Text("Chat with $shopName")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Text("Chat with - $shopName"),
        if (shopCity != null) Text("City: $shopCity"),
          ],
        ),
      ),
    );
  }
}
