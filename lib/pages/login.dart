import 'package:flutter/material.dart';
import 'package:telephon_application/components/lr_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});


  //Login and Password text field controllers
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.lock, 
                size: 100
              ),

              const SizedBox(height: 50),

              LRTextField(
                controller: loginController, 
                inHintText: 'Login', 
                inObscureText: false
              ),

              const SizedBox(height: 10),

              LRTextField(
                controller: passwordController, 
                inHintText: 'Password', 
                inObscureText: true
              )
            ],
          ),
        ),
      )
    );
  }
}