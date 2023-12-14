import 'package:flutter/material.dart';

class LRTextField extends StatelessWidget {
  final controller;
  final String inHintText;
  final bool inObscureText;

  const LRTextField({
    super.key,
    required this.controller,
    required this.inHintText,
    required this.inObscureText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          style: TextStyle(color:Colors.grey),
          controller: controller,
          obscureText: inObscureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: inHintText,            
          )
        )
    );
  }
}