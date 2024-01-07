import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudServices{
  User? _currentUser = FirebaseAuth.instance.currentUser;

  Future addContacts(String name, String phoneNumber, String email)async{
    Map<String,dynamic> contactData ={
      "name":name,
      "phoneNumber":phoneNumber,
      "email":email
    };
    try{
      await FirebaseFirestore.instance.collection("Users").doc(_currentUser!.uid).collection("contacts").add(contactData);
      print("Data added");
    }catch(e){
      print(e.toString());
    }
  }

  Future addUser(String email, String name, String uid)async{
    Map<String,dynamic> userData ={
      "email":email,
      "name":name,
      "uid":uid
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