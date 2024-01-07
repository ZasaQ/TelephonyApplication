import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/components/lr_button.dart';
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
              StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Users').snapshots(), 
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return Text('Username not found');
                } else {
                  return Column(
                   children:snapshot.data!.docs.map((DocumentSnapshot document){
                    Map<String,dynamic> data= document.data()! as Map<String, dynamic>;
                    String userName = data['name'].toString();
                    String userUid = data['uid'];
                    if(userUid==_auth.currentUser!.uid){
                      return Text('Your current username: $userName');
                    }else{
                      return Container();
                    }
            }).toList().cast(),
            
          );
                  //Text('Your current username: $userName $userUid',style: TextStyle(fontWeight: FontWeight.w600),);
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
                child: LRButton(
                  inText: "Change username",
                  onPressed: () async{
                     String userUid = _auth.currentUser!.uid;
                     String? docId = await getUserIdByUid(userUid);
                    
                 
                     updateUserName(docId.toString(), _newUsernameController.text);
                  }, 
                  
                ),
              ),
            ],
          ),
      ),
      );
  }
  Future<String?> getUserIdByUid(String currentUserId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: currentUserId).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user ID by UID: $e');
      return null;
    }
  }


  Future updateUserName(String userId, String newUserName) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({'name': newUserName});
      print('User Name updated successfully');
    } catch (e) {
      print('Error updating user name: $e, $userId');
    }
  }
    
}