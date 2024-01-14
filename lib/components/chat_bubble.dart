import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String msg;
  const ChatBubble({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[700],

      ),
      child: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}