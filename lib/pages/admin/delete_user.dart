import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/controllers/crud_services.dart';

class AdminDeleteUser extends StatefulWidget {
  const AdminDeleteUser({super.key});

  @override
  State<AdminDeleteUser> createState() => _AdminDeleteUserState();
}

class _AdminDeleteUserState extends State<AdminDeleteUser> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete user from database"),
      ),
      body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').orderBy('name').snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                return Text("Can't upload data");
              }
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(
                  child: Text("loading"),
          
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    
                    Column(
                      children: snapshot.data!.docs.map((DocumentSnapshot document){
                      Map<String,dynamic> data= document.data()! as Map<String, dynamic>;
                      if(_auth.currentUser!.email != data['email']){
                        return ListTile(
                          title:Text(data["name"]),
                          subtitle:Text(data["email"]),
                          trailing: Wrap(
                            spacing: 12,
                            children: [
                              IconButton(
                                onPressed: () {  
                                  CrudServices().deleteFirestoreUser(data['uid']);
                                  CrudServices().deleteAccountById(data['uid']);
                                },
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                        );
                      }else{
                        return Container();
                      }
                    }).toList().cast(),
                    ),
                  ],
                ),
              );
            }
      ),
    );
  }
}