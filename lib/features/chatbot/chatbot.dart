import 'package:flutter/material.dart';
import 'package:onbook_app/general/themes/app_colors.dart';
import 'package:onbook_app/general/themes/app_fonts.dart';

class ChatPopupDialog extends StatefulWidget {
  const ChatPopupDialog({super.key});

  @override
  State<ChatPopupDialog> createState() => _ChatPopupDialogState();
}

class _ChatPopupDialogState extends State<ChatPopupDialog> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // TODO: handle sending logic
      print('Message: $message');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Chat with Support'),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Type your message...',
              filled: true,
              fillColor: AppColors.bggrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Send',),
            ),
          ),
        ],
      ),
    );
  }
}
