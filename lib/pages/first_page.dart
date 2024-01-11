// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors


import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/models/call_model.dart';
import 'package:telephon_application/models/user_model.dart';
import 'package:telephon_application/pages/call.dart';
import 'package:telephon_application/pages/callList_page.dart';
import 'package:telephon_application/pages/messages.dart';

class FirstPage extends StatefulWidget {
  final ReceivedAction? receivedAction;
   FirstPage({super.key, required this.receivedAction});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
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
        activationDate: userMap['activationDate']
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

  int _selectedIndex = 0;
  final currentUser = FirebaseAuth.instance.currentUser!;
  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex=index;
    });
  }
  void userSignOut() async{
    try{
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: currentUser!.uid).get();
        String tokenValue = FirebaseMessaging.instance.getToken().toString();
        await FirebaseFirestore.instance.collection("Users").doc(querySnapshot.docs.first.id).update(
            {
              'token': "",
            },
        );
        print("token is empty");
        FirebaseAuth.instance.signOut();
    }catch (e){
      print("Can't delete token value");
    }
  }

  final List _pages = [
    //homepage
   // HomePage(),
    //profilepage
    MessagesPage(),
    CallsPage(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _appBar(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Contacts'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'), 
        ],
        selectedItemColor: Colors.lightBlue,
        
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  maxRadius: 52,
                  child: Text(currentUser.email.toString()[0],style: TextStyle(fontSize: 25),), //first letter of username
                ),
                Text(currentUser.email.toString()),
              ],
            ),  
          ),
          //home page
          ListTile(
            leading: Icon(Icons.person),
            title: Text("About"),
            onTap:(){
              //go to homepage
              Navigator.pop(context);
              Navigator.pushNamed(context, '/aboutpage');
            }
          ),
          //settings page
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap:(){
              //go to homepage
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settingspage');
            }
          ),
          ListTile(
            tileColor: Colors.black,
            leading: Icon(Icons.logout,color: Colors.white,),
            title: Text("Log out"),
            titleTextStyle: TextStyle(color: Colors.white),
            onTap:(){
              
              userSignOut();
            }
          ),
        ],
        
      ),
      ),
      body: _pages[_selectedIndex],
        
    );
  }
  AppBar _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              child: Icon(Icons.flutter_dash),
            )
          ),
          Text("AppName"),
        ],
      ),
      actions: [
        IconButton(onPressed: userSignOut, icon: Icon(Icons.logout, color: Colors.black,)),
      ],
      
    );
  }
  
}