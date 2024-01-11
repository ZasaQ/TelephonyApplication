import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/services/firestore_databases.dart';

class CrudServices{
  User? _currentUser = FirebaseAuth.instance.currentUser;

  deleteAccount()async{
    String? uid = await getUserIdByUid(FirebaseAuth.instance.currentUser!.uid.toString());
    try{
      User? user=FirebaseAuth.instance.currentUser;
      
      if(user != null){
        await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .delete();
        await user.delete();
        FirebaseAuth.instance.signOut();
        print("Account deleted");
      }else{
        print("Couldn't find current user");
      }
    }catch (e){
      print("error: $e");
    }
  }
  getToken(String currentUser)async{
    String? uid = await getUserIdByUid(currentUser);
    String token = "";
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: currentUser).get();
      if(querySnapshot.docs.isNotEmpty){
        token=querySnapshot.docs.first['token'];
      }
      if(token.isNotEmpty){
        FirebaseAuth.instance.signOut();
        AlertDialog(
          backgroundColor: Colors.lightBlue.shade300,
          title: Text("You are loged in on other device", style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
        );
        print("Cant't update token");
      }else{
        FirebaseMessaging.instance.getToken().then(
        (token) async {

          await FirebaseFirestore.instance.collection("Users").doc(uid).update(
          {
            'token': token,
          },
          );
        },
        );
        print('Token updated');
      }
  }
  Future addContacts(String name, String phoneNumber, String email)async{
    Map<String,dynamic> contactData ={
      "name":name,
      "email":email
    };
    try{
      await FirebaseFirestore.instance.collection("Users").doc(_currentUser!.uid).collection("contacts").add(contactData);
      print("Data added");
    }catch(e){
      print(e.toString());
    }
  }

  Future addUser(String email, String name, String uid, String token)async{
    Map<String,dynamic> userData ={
      "email":email,
      "name":name,
      "uid":uid,
      "token": token
    };
    try{
      await FirebaseFirestore.instance.collection("Users").add(userData);
      print("Data added");
    }catch(e){
      print(e.toString());
    }
  }
  

  Stream<QuerySnapshot> getContacts() async*{
    var contactsQuery = FirebaseFirestore.instance.collection("Users").doc(_currentUser!.uid).collection("contacts").snapshots();
    
    yield* contactsQuery;
  }

  Stream<QuerySnapshot> getUsers() async*{
    var usersQuery = FirebaseFirestore.instance.collection("Users").snapshots();

    yield* usersQuery;
  }
}