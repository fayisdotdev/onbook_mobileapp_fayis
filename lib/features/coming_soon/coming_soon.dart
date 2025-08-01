import 'package:flutter/material.dart';
import 'package:onbook_app/general/themes/app_colors.dart';

class ComingSoonPage extends StatelessWidget {
  final String title;
  final String message;

  const ComingSoonPage({
    super.key,
    this.title = 'Coming Soon',
    this.message = 'This feature is not yet available.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.secondary,
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
