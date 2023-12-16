import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DebugHomePage extends StatelessWidget {
  const DebugHomePage({super.key});

void userSignOut() {
  FirebaseAuth.instance.signOut();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: userSignOut, icon: Icon(Icons.logout))
      ]),
      body: Center(child: Text('Debug Home Page'))
    );
  }
}