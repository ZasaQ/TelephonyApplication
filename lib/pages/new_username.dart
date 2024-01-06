import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/controllers/crud_services.dart';

class NewUsername extends StatefulWidget {
  const NewUsername({super.key});

  @override
  State<NewUsername> createState() => _NewUsernameState();
}



class _NewUsernameState extends State<NewUsername> {
  TextEditingController _newUsernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CrudServices _crudServices = CrudServices();

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text("Change username"),
      ),
      body: Center(
        child: Column(
            children: [
               SizedBox(
                height: 20,
              ),
              FutureBuilder<DocumentSnapshot>(
              future: getUserData(_auth.currentUser!.uid), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null || !snapshot.data!.exists) {
                  return Text('Username not found');
                } else {
                  
                  var userData = snapshot.data!.data() as Map<String, dynamic>;
      
                  String userName = userData['name'];
                  String userUid = userData['uid'];
        
                  return Text('Your current username: $userName $userUid',style: TextStyle(fontWeight: FontWeight.w600),);
                }
              },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                      return null;
                    },
                    controller: _newUsernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.padding_sharp),
                      label: Text("New username"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async{
                     updateUserName(_auth.currentUser!.uid, _newUsernameController.text);
                  }, 
                  child: Text('Change username'),
                ),
              ),
            ],
          ),
      ),
      );
  }

  Future<DocumentSnapshot<Object?>> getUserData(String userId) async {
    try {
      // Pobierz dokument użytkownika z kolekcji "users" na podstawie ID
      DocumentSnapshot<Object?> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      return snapshot;
    } catch (e) {
      print('Error getting user data: $e');
      throw e;
    }
  }

  Future<void> updateUserName(String userId, String newUserName) async {
    try {
     
      DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(userId);

      await userRef.update({
        'name': newUserName,
      });

      print('User Name updated successfully');
    } catch (e) {
      print('Error updating user name: $e');
    }
  }
    
}