// ignore_for_file: prefer_const_constructors


import 'package:flutter/material.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/add");
        }, 
        child: Icon(Icons.person_add),
      ),
      backgroundColor: Colors.grey[300],
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: Column(
          children:[
            searchField(),
            ListTile(
              leading: CircleAvatar(child: Text("T")), //first letter of contact
              title: Text("kontakt"),
              subtitle: Text("123456789"),
              trailing: IconButton(icon: Icon(Icons.call), onPressed: () {},),
            ),
          ],
        ),
      ),
      );
  }


  Container searchField(){
    return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),

            ),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(
                  Icons.search, 
                  color: Colors.grey[700], 
                  size: 20,),
                prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
                border: InputBorder.none,
                hintText: 'Wyszukaj',
                hintStyle: TextStyle(color:Colors.grey[700], fontSize: 20),
              ),
            ),
    );
  
  }

  ListView contactList(){
    return ListView(
        children: [
          ListTile(
            leading: CircleAvatar(child: Text("T")), //first letter of contact
            title: Text("kontakt"),
            subtitle: Text("123456789"),
            trailing: IconButton(icon: Icon(Icons.call), onPressed: () {},),
          ),
        ],
    );
  }
}
