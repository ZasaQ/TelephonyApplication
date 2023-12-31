import 'package:flutter/material.dart';

class LRButton extends StatelessWidget {
  final String inText;
  final Function()? onPressed;

  const LRButton({super.key, required this.inText, required this.onPressed});

  @override
  Widget build(BuildContext context) {    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 97, 97, 97), 
        borderRadius: BorderRadius.circular(5)
      ),
      child: TextButton(
        onPressed: onPressed, 
        child: Center(child: Text(inText,
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
          ),
        )
      ),
    );
  }
}