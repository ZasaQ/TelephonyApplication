import 'package:flutter/material.dart';

class LRButton extends StatelessWidget {
  final Function()? onPressed;

  const LRButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22),
      margin: EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(color: Color.fromARGB(255, 97, 97, 97), borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          'Sign In',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
        ),
      )
    );
  }
}