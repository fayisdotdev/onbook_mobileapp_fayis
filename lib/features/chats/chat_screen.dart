import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onbook_app/general/models/shop/shop_public_model.dart';
import 'package:provider/provider.dart';
import 'package:onbook_app/general/providers/message_provider.dart';

class ChatScreen extends StatefulWidget {
  final String shopId;
  final String shopName;
  final String? shopCity;
  final String shopEmail;

  const ChatScreen({
    super.key,
    required this.shopId,
    required this.shopName,
    this.shopCity,
    required this.shopEmail,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  void _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    try {
      await Provider.of<MessageProvider>(
        context,
        listen: false,
      ).sendMessage(messageText);

      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to send: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(
      context,
      listen: false,
    );

    // Set the selected shop so MessageProvider knows where to send messages
    messageProvider.setSelectedShop(
      ShopPublicModel(
        shopId: widget.shopId,
        shopName: widget.shopName,
        city: widget.shopCity,
        ownerName: widget.shopEmail,
        shopEmail:
            widget.shopEmail, // ✅ Make sure ShopPublicModel supports this
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.shopName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: messageProvider.getMessagesStream(widget.shopId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == _currentUserId;

                    // Swap sides: if I'm the sender, put message on LEFT
                    return Align(
                      alignment: isMe
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors
                                    .grey
                                    .shade300 // my messages now grey
                              : Theme.of(
                                  context,
                                ).primaryColor, // shop messages now primary
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isMe
                                ? const Radius.circular(0)
                                : const Radius.circular(12),
                            bottomRight: isMe
                                ? const Radius.circular(12)
                                : const Radius.circular(0),
                          ),
                        ),
                        child: Text(
                          msg['message'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: isMe
                                ? Colors.black
                                : Colors.white, // match new colors
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input field
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
