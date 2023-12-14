// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:telephon_application/pages/homepage.dart';
import 'package:telephon_application/pages/profilepage.dart';
import 'package:telephon_application/pages/settingspage.dart';

class FirstPage extends StatefulWidget {
   FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  final List _pages = [
    //homepage
    HomePage(),
    //profilepage
    ProfilePage(),
    //settingspage
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("App Bar")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 141, 141, 141),
        child: Column(
        children: [
          DrawerHeader(
            child: Icon(
              Icons.favorite,
              size: 48,
            ),  
          ),
          //home page
          ListTile(
            leading: Icon(Icons.home),
            title: Text("HOME"),
            onTap:(){
              //go to homepage
              Navigator.pop(context);
              Navigator.pushNamed(context, '/homepage');
            }
          ),
          //settings page
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("SETTINGS"),
            onTap:(){
              //go to homepage
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settingspage');
            }
          ),
        ],
      ),
      ),
      body: _pages[_selectedIndex],
        
    );
  }
}