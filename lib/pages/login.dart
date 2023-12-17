import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/components/lr_text_field.dart';
import 'package:telephon_application/components/lr_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Login and Password text field controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void showAlertMessage(final String message) {
    showDialog(context: context, builder: (context) => Center(
      child: AlertDialog(
        backgroundColor: Colors.lightBlue.shade300,
        title: Text(message, textAlign: TextAlign.center)))
    );
  }

  void userSignIn() async {
    // Try to Sign In
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text
      );

      // Pop up loading circle
      Navigator.pop(context);

    } on FirebaseAuthException catch (excep) {
      // Pop up loading circle
      Navigator.pop(context);

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        return showAlertMessage('Text fields can not be empty');
      } else if (excep.code == 'user-not-found') {
        return showAlertMessage('No user found for this email');
      } else if (excep.code == 'wrong-password') {
        return showAlertMessage('Wrong passowrd for this email');
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
        
                const Image(image: AssetImage('lib/images/lock_icon.png'), height: 100, width: 100,),
        
                const SizedBox(height: 30),
        
                Center(
                  child: Text('Welcome! Try to Sign In', style: TextStyle(color: Colors.grey[600])),
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
        
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot password?',
                        style: TextStyle(color: Colors.grey[600])
                      )
                    ]
                  )
                ),
        
                const SizedBox(height: 40),
        
                //Sign In button
                LRButton(onPressed: userSignIn),
        
                const SizedBox(height: 40),
        
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(thickness: 1, color: Colors.grey[700],),
                ),
        
                Center(child: Text('Or continue with', style: TextStyle(color: Colors.grey[600]))),
        
                const SizedBox(height: 20),
        
                // Google Authentication
                Center(
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
        
                const SizedBox(height: 70),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No Account? ', 
                      style: TextStyle(color: Colors.grey[600])
                    ),
                    Text('Sign Up!', 
                      style: TextStyle(color: Colors.lightBlue.shade300, fontWeight: FontWeight.bold)
                    )
                  ],
                )
                //Center(child: Text('No Account? Sign Up!', style: TextStyle(color: Colors.grey[600])))
              ],
            ),
          ),
        ),
      )
    );
  }
}