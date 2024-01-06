import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController _oldPasswordController=TextEditingController();
  TextEditingController _newPasswordController=TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  changePassword({email,oldPassword,newPassword}) async{
    final credential = EmailAuthProvider.credential(email:email,password:oldPassword);
    await _auth.currentUser!.reauthenticateWithCredential(credential).then((value) {
      _auth.currentUser!.updatePassword(newPassword);
    }).catchError((error){
      print(error.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change password")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    controller: _oldPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.password_sharp),
                      label: Text("Old Password"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
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
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.padding_sharp),
                      label: Text("New password"),
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
                    await changePassword(
                      email: _auth.currentUser!.email.toString(),
                      oldPassword: _oldPasswordController.text,
                      newPassword: _newPasswordController.text,
                    );
                    print("Password changed");
                    _oldPasswordController.clear();
                    _newPasswordController.clear();
                    _auth.signOut();
                  }, 
                  child: Text('Change password'),
                ),
              ),
          ],
        ),
      )
    );
  }
}