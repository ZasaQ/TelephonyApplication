// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/components/appBar.dart';
import 'package:telephon_application/controllers/getUid.dart';
import 'package:telephon_application/pages/callList_page.dart';
import 'package:telephon_application/pages/messages.dart';

class FirstPage extends StatefulWidget {
   FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}
class _FirstPageState extends State<FirstPage> {
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
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .where('uid', isEqualTo: currentUser.uid)
                  .where('role', isEqualTo: 'admin')
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                String data = snapshot.connectionState.toString();
                
                if(data.isNotEmpty){
                return SizedBox(
                  height: 200,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Admin functions:"),
                      ),
                      
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Delete User"),
                        onTap:(){
                          //go to homepage
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/settingspage');
                        }
                      ),
                       ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Change user role"),
                        onTap:(){
                          //go to homepage
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/settingspage');
                        }
                      ),
                    ],
                  ),
                );
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
              
              userSignOut(currentUser!.uid);
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