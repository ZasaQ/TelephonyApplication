import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:telephon_application/models/user_model.dart';
import 'package:telephon_application/pages/call.dart';
import 'package:telephon_application/models/call_model.dart';
import 'package:telephon_application/services/firestore_databases.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class DebugHome extends StatefulWidget {
  final ReceivedAction? receivedAction;
  const DebugHome({super.key, required this.receivedAction});

  @override
  State<DebugHome> createState() => _DebugHomeState();
}

class _DebugHomeState extends State<DebugHome> {
  handleNotification() {
    if (widget.receivedAction != null) {
      Map userMap = widget.receivedAction!.payload!;
      UserModel user = UserModel(
          uid: userMap['uid'],
          name: userMap['name'],
          email: userMap['email']);
      CallModel call = CallModel(
        id: userMap['id'],
        channel: userMap['channel'],
        caller: userMap['caller'],
        called: userMap['called'],
        active: jsonDecode(userMap['active']),
        accepted: true,
        rejected: jsonDecode(userMap['rejected']),
        connected: true,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CallPage(user: user, callHandler: call);
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000)).then(
      (value) {
        handleNotification();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "xD",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [IconButton(onPressed: () => {FirebaseAuth.instance.signOut()}, icon: Icon(Icons.logout, color: Colors.black,)),],
        ),
        body: StreamBuilder<List<DocumentSnapshot>>(
          stream: usersData(),
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: userSnapshot.data!.length,
                itemBuilder: (context, index) {
                  var data = userSnapshot.data![index];
                  UserModel user = UserModel(
                      uid: data['uid'],
                      name: data['name'],
                      email: data['email']);

                  return user.uid == FirebaseAuth.instance.currentUser.toString()
                      ? const SizedBox.shrink()
                      : ListTile(
                          title: Text(user.name),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CallPage(
                                      user: user,
                                      callHandler: CallModel(
                                        id: null,
                                        channel: "${FirebaseAuth.instance.currentUser!.email}_and_${user.name}",
                                        caller: FirebaseAuth.instance.currentUser!.email.toString(),
                                        called: user.name,
                                        active: null,
                                        accepted: null,
                                        rejected: null,
                                        connected: null,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.video_call_rounded,
                              color: Colors.blue,
                            ),
                          ),
                        );
                },
              );
            }
            return const Center(
              child: Text("NO USERS"),
            );
          },
        ),
      ),
    );
  }
}