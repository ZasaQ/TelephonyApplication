// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors


import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:telephon_application/components/appBar.dart';
import 'package:telephon_application/services/utils.dart';

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

  Widget buildAdminFunctions() {
    return SizedBox(
      height: 200,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text("Admin functions:"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Delete User"),
            onTap: () {
              // go to homepage
              Navigator.pop(context);
              Navigator.pushNamed(context, '/adminDeleteUser');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Change user role"),
            onTap: () {
              // go to homepage
              Navigator.pop(context);
              Navigator.pushNamed(context, '/adminChangeRole');
            },
          ),
        ],
      ),
    );
  }

  int _selectedIndex = 0;
  final currentUser = FirebaseAuth.instance.currentUser!;
  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex=index;
    });
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
      appBar: MainAppBar(currentUser: currentUser.uid),
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
         FutureBuilder(
            future: ifAdmin(),
            builder: (context, AsyncSnapshot<bool?> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              bool? isAdmin = snapshot.data;

              if(isAdmin!){
              return buildAdminFunctions();
              }else{
                return Container();
              }
            },
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
              
              userSignOut(currentUser.uid);
            }
          ),
        ],
      ),
      ),
      body: _pages[_selectedIndex],
        
    );
  }
  Future<bool?> ifAdmin() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('uid', isEqualTo: currentUser.uid)
          .where('role', isEqualTo: 'admin')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error checking admin status: $e");
      return null;
    }
  }
}