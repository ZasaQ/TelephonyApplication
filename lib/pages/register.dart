import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/components/lr_text_field.dart';
import 'package:telephon_application/components/lr_button.dart';
import 'package:telephon_application/services/google_auth.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onSignInTap;
  RegisterPage({super.key, required this.onSignInTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Login and Password text field controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void showAlertMessage(final String message) {
    showDialog(context: context, builder: (context) => Center(
      child: AlertDialog(
        backgroundColor: Colors.lightBlue.shade300,
        title: Text(message, style: TextStyle(color: Colors.white), textAlign: TextAlign.center)))
    );
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void userSignUp() async {
    // Try to Sign Up
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text
        );
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        return showAlertMessage('Password must be the same!');
      }

    } on FirebaseAuthException catch (excep) {
      Navigator.pop(context);

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        return showAlertMessage('Email and password can\'t be empty');
      } else {
        return showAlertMessage(excep.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
        
                const Image(image: AssetImage('lib/images/register_icon.png'), height: 90, width: 90,),
        
                const SizedBox(height: 30),
        
                Center(
                  child: Text('Welcome! Try to Sign Up', style: TextStyle(color: Colors.grey[600])),
                ),
        
                const SizedBox(height: 20),
        
                // Email text field
                LRTextField(
                  controller: emailController, 
                  inHintText: 'Email', 
                  inObscureText: false
                ),
        
                const SizedBox(height: 10),
        
                // Passowrd text field
                LRTextField(
                  controller: passwordController, 
                  inHintText: 'Password', 
                  inObscureText: true
                ),
        
                const SizedBox(height: 10),

                // Confirm passowrd text field
                LRTextField(
                  controller: confirmPasswordController, 
                  inHintText: 'Confirm password', 
                  inObscureText: true
                ),
                
                const SizedBox(height: 40),
        
                //Sign Up button
                LRButton(inText: 'Sign Up', onPressed: userSignUp),

                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(thickness: 1, color: Colors.grey[700],),
                ),
        
                Center(child: Text('Or continue with', style: TextStyle(color: Colors.grey[600]))),
        
                const SizedBox(height: 20),
        
                // Google Authentication
                Center(
                  child: GestureDetector(
                    onTap: () => GoogleAuth().signInWithGoogle(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]
                      ),
                      child: Image(
                        image: AssetImage('lib/images/google_icon.png'), 
                        height: 50,
                      )
                    ),
                  ),
                ),
        
                const SizedBox(height: 50),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Have an account? ', 
                      style: TextStyle(color: Colors.grey[600])
                    ),
                    GestureDetector(
                      onTap: widget.onSignInTap,
                      child: Text('Sign In!', 
                        style: TextStyle(color: Colors.lightBlue.shade300, fontWeight: FontWeight.bold)
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}