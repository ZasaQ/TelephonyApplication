// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }

  final List _pages = [
    //homepage
   // HomePage(),
    //profilepage
    MessagesPage(),
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
              child: Icon(Icons.contact_page),
            )
          ),
          Text("Kontakty"),
        ],
      ),
      actions: [
        IconButton(onPressed: userSignOut, icon: Icon(Icons.logout, color: Colors.black,)),
      ],
      
    );
  }
  
}