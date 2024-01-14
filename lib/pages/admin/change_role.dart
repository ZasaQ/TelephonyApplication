import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/services/utils.dart';

class AdminChangeRole extends StatefulWidget {
  const AdminChangeRole({super.key});

  @override
  State<AdminChangeRole> createState() => _AdminChangeRoleState();
}

class _AdminChangeRoleState extends State<AdminChangeRole> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isAdmin = false;
  bool isUser = false;
  bool newRole = false;
  bool newUserRole = false;
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
              return Column(
                children: [
                  Column(
                    children:[
                       Visibility(
                          visible: isAdmin,
                          child: Text(
                            "User is already an admin",
                            style: TextStyle(color: Colors.black),
                          ),
                       ),
                       Visibility(
                          visible: newRole,
                          child: Text(
                            "User role has change[Admin]",
                            style: TextStyle(color: Colors.black),
                          ),
                       ),
                       Visibility(
                          visible: isUser,
                          child: Text(
                            "User isNot and admin",
                            style: TextStyle(color: Colors.black),
                          ),
                       ),
                       Visibility(
                          visible: newUserRole,
                          child: Text(
                            "User role has change[User]",
                            style: TextStyle(color: Colors.black),
                          ),
                       ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: snapshot.data!.docs.map((DocumentSnapshot document){
                        Map<String,dynamic> data= document.data()! as Map<String, dynamic>;
                        if(_auth.currentUser!.email != data['email']){
                         return ListTile(
                                title:Text(data["name"]),
                                subtitle:Text(data["email"]),
                                trailing: Wrap(
                                  spacing: 20,
                                  children: [
                                    IconButton(
                                      onPressed: () async {  
                                        if(data['role']=='admin'){
                                          setState(() {
                                            isAdmin=!isAdmin;
                                          });
                                        }else{
                                          String? uid = await getUserIdByUid(data['uid']);
                                           await FirebaseFirestore.instance.collection("Users").doc(uid).update(
                                              {
                                                'role': 'admin',
                                              },
                                          );
                                          setState(() {
                                            newRole=!newRole;
                                          });
                                        }
                                      },
                                      icon: Icon(Icons.admin_panel_settings),
                                    ),
                                    IconButton(
                                      onPressed: () async{  
                                        if(data['role']=='user'){
                                          setState(() {
                                            isUser=!isUser;
                                          });
                                        }else{
                                          String? uid = await getUserIdByUid(data['uid']);
                                           await FirebaseFirestore.instance.collection("Users").doc(uid).update(
                                              {
                                                'role': 'user',
                                              },
                                          );
                                          setState(() {
                                            newUserRole=!newUserRole; 
                                          });
                                        }
                                      },
                                      icon: Icon(Icons.supervised_user_circle),
                                    ),
                                  ],
                                ),
                              );
                        }else{
                          return Container();
                        }
                      }).toList().cast(),
                      ),
                    ),
                  ),
                ],
              );
            }
      ),
    );
  }
}