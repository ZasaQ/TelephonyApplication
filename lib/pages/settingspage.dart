// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Column(
          children: [
          Column(
            children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  maxRadius: 52,
                  child: Text(_auth.currentUser!.email.toString()[0],style: TextStyle(fontSize: 25),), //first letter of username
                ),
                Text(_auth.currentUser!.email.toString()),
                
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2),
                borderRadius: BorderRadius.circular(16)
              ),
              leading: Icon(Icons.supervised_user_circle),
              title: Text("Change username"),
              onTap:(){
                //go to homepage 
                Navigator.pop(context);
                Navigator.pushNamed(context, '/newUsername');
              }
            ),
          ),
           Padding(
             padding: const EdgeInsets.all(16.0),
             child: ListTile(
              contentPadding: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2),
                borderRadius: BorderRadius.circular(16)
              ),
              leading: Icon(Icons.password_rounded),
              title: Text("Change password"),
              onTap:(){
                //go to homepage
                Navigator.pop(context);
                Navigator.pushNamed(context, '/newPassword');
              }
                       ),
           ),
        ],),
      ),
    );
  }
}
