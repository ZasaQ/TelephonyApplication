import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:telephon_application/components/lr_text_field.dart';
import 'package:telephon_application/components/lr_button.dart';

class ForgotPasswordPage extends StatefulWidget {

  ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  void showAlertMessage(final String message) {
    showDialog(context: context, builder: (context) => Center(
      child: AlertDialog(
        backgroundColor: Colors.lightBlue.shade300,
        title: Text(message, style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
        )
    ));
    emailController.clear();
  }

  void resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text).then((value) => Navigator.pop(context)
      );
    } on FirebaseAuthException catch (excep) {
      return showAlertMessage(excep.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(backgroundColor: Colors.grey[300]),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),

            Center(
              child: Text('Please type your email to receive password reset request', 
                style: TextStyle(color: Colors.grey[600])
              ),
            ),
        
            const SizedBox(height: 20),
        
            // Email text field
            LRTextField(
              controller: emailController, 
              inHintText: 'Email', 
              inObscureText: false
            ),
        
            const SizedBox(height: 30),

            LRButton(inText: 'Send Request', onPressed: resetPassword)
          ]
        ),
      )
    );
  }
}