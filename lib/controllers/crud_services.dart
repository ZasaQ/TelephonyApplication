import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudServices{
  User? user = FirebaseAuth.instance.currentUser;

  Future addContacts(String name, String phoneNumber, String email)async{
    Map<String,dynamic> contactData ={
      "name":name,
      "phoneNumber":phoneNumber,
      "email":email
    };
    try{
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("contacts").add(contactData);
      print("Data added");
    }catch(e){
      print(e.toString());
    }
  }

}