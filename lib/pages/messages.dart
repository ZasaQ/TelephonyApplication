import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/controllers/crud_services.dart';
import 'package:telephon_application/pages/chat_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/newMsg");
        }, 
        child: Icon(Icons.chat_bubble),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text("Can't upload data");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: Text("loading"),

            );
          }
          return ListView(
            children:snapshot.data!.docs.map((DocumentSnapshot document){
              Map<String,dynamic> data= document.data()! as Map<String, dynamic>;
              if(_auth.currentUser!.email != data['email']){
                return ListTile(
                  leading:CircleAvatar(child: Text(data["name"][0])), //first letter of contact
                  title:Text(data["name"]),
                  subtitle:Text(data["email"]),
                  onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                    userEmail: data['email'],
                    usersId: data['uid'],
                  ),));
                  },
                );
              }else{
                return Container();
              }
            }).toList().cast(),
            
          );
        }, 
      ),
    );
  }
}