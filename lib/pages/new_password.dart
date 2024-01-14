import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/components/lr_button.dart';
import 'package:telephon_application/controllers/getUid.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController _oldPasswordController=TextEditingController();
  TextEditingController _newPasswordController=TextEditingController();
  TextEditingController _confirmPasswordController=TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void showAlertMessage(final String message) {
    showDialog(context: context, builder: (context) => Center(
      child: AlertDialog(
        backgroundColor: Colors.lightBlue.shade300,
        title: Text(message, style: TextStyle(color: Colors.white), textAlign: TextAlign.center)))
    );
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  changePassword({email,oldPassword,newPassword,confirmPassword}) async{
    final credential = EmailAuthProvider.credential(email:email,password:oldPassword);
    try{
      if(newPassword == confirmPassword && oldPassword.isNotEmpty){
          await _auth.currentUser!.reauthenticateWithCredential(credential).then((value) {
            _auth.currentUser!.updatePassword(newPassword);
          }).catchError((error){
             print(error.toString());
          });
      }else {
        return showAlertMessage('Password must be the same!');
      }
    } on FirebaseAuthException catch (excep) {
      if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
        return showAlertMessage('Fields can\'t be empty');
      } else {
        return showAlertMessage(excep.code);
      }
    }
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
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                      return null;
                    },
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.verified),
                      label: Text("Confirm password"),
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
                  inText: "Change password",
                  onPressed: () async{
                    await changePassword(
                      email: _auth.currentUser!.email.toString(),
                      oldPassword: _oldPasswordController.text,
                      newPassword: _newPasswordController.text,
                      confirmPassword: _confirmPasswordController.text,
                    );
                    print("Password changed");
                    _oldPasswordController.clear();
                    _newPasswordController.clear();
                    _confirmPasswordController.clear();
                    userSignOut(_auth.currentUser!.uid);
                  }, 
                  
                ),
              ),
          ],
        ),
      )
    );
  }
}