// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/pages/homepage.dart';
import 'package:telephon_application/pages/messages.dart';
import 'package:telephon_application/pages/settingspage.dart';

class FirstPage extends StatefulWidget {
   FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;
  final currentUser = FirebaseAuth.instance.currentUser!;
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
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
    HomePage(),
    //profilepage
    MessagesPage(),
    //settingspage
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _appBar(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Kontakty'),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Wiadomosci'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
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
          ListTile(
            tileColor: Colors.black,
            leading: Icon(Icons.logout,color: Colors.white,),
            title: Text("WYLOGUJ SIE"),
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
      bottom: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width*8,80),
        child: SizedBox(child: searchField()),
      ),
    );
  }
  SizedBox searchField(){
    return SizedBox(
            width: MediaQuery.of(context).size.width*.9,
                child: TextFormField(
                  onChanged: (value){
                    setState(() {
                      
                    });
                  },
                  focusNode: _searchFocusNode,
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    label: Text("Wyszukaj"),
                    suffixIcon: _searchController.text.isNotEmpty? IconButton(onPressed: (){_searchController.clear();_searchFocusNode.unfocus();}, icon: Icon(Icons.close)):null,
                  ),
                ),
            
    );
  }
}