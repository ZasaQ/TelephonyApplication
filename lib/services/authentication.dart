import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/pages/first_page.dart';
import 'package:telephon_application/services/login_or_register_handler.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FirstPage(receivedAction: null,);
          }
          else {
            return LoginOrRegisterHandler();
          }
        }
      )
    );
  }
}