import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DebugHomePage extends StatelessWidget {
  DebugHomePage({super.key});

  final currentUser = FirebaseAuth.instance.currentUser!;

  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: userSignOut, icon: Icon(Icons.logout))
      ]),
      body: Center(child: Text('Debug Home Page | Logged User: ${currentUser.email}'))
    );
  }
}