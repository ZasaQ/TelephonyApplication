import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/components/lr_button.dart';

class NewContact extends StatefulWidget {
  const NewContact({super.key});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  TextEditingController _emailController=TextEditingController();
  bool ifEmailTrue = false;
  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj kontakt"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children:[
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width/1.5,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                          return null;
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Find email address"),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      bool? ifUsrEmail = await searchForEmail(_emailController.text);
                      print(ifUsrEmail);
                      if (ifUsrEmail.toString()==true) {
                        print('exists');
                        Text("User exists");
                        ifEmailTrue=true;
                      } else {
                        print('doesnt exists');
                        Text("User doesn't exists");
                      }
                    }, 
                    child: Text("search"),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width,
                child: LRButton(
                  inText: "Dodaj",
                  onPressed: (){
                    if(_formKey.currentState!.validate()&& ifEmailTrue==true){
                     // CrudServices().addContacts(_nameController.text, _phoneNumberController.text, _emailController.text);
                      
                      _emailController.clear();
                      
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool?> searchForEmail(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Users').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error getting user ID by UID: $e');
      return null;
    }
  }
  /*Future<List<String>> getEmailListFromFirebase() async {
    List<String> emailList = [];

    try {
      List<User?> userList = await FirebaseAuth.instance
        .userChanges()
        .map((user) => user != null ? user : null)
        .toList();

      for (User? user in userList) {
        if (user != null) {
          // Add user emails to the list
          emailList.add(user.email!);
        }
      }
    } catch (e) {
      print('Error fetching email list: $e');
    }

    return emailList;
  }
  Future<bool> searchForEmail(String searchEmail) async {
    List<String> emailList = await getEmailListFromFirebase();

    if (emailList.contains(searchEmail)) {
      print('Email address found: $searchEmail');
      return true;
    } else {
      print('Email address not found: $searchEmail');
      return false;
    }
  }
  */

}