import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/components/lr_text_field.dart';
import 'package:telephon_application/components/lr_button.dart';
import 'package:telephon_application/pages/forgot_password.dart';
import 'package:telephon_application/services/google_auth.dart';

class LoginPage extends StatefulWidget {
  final Function()? onSignUpTap;
  LoginPage({super.key, required this.onSignUpTap});

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
        title: Text(message, style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
        )
    ));
    emailController.clear();
    passwordController.clear();
  }

  void userSignIn() async {
    // Try to Sign In
    /*showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });*/

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text
      ).then((userCredential) => null);
    } on FirebaseAuthException catch (excep) {
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
        
                const Image(image: AssetImage('lib/images/lock_icon.png'), height: 90, width: 90,),
        
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                        },
                        child: Text('Forgot password?',
                          style: TextStyle(color: Colors.lightBlue[300], fontWeight: FontWeight.bold)
                        ),
                      )
                    ]
                  )
                ),
        
                const SizedBox(height: 40),
        
                //Sign In button
                LRButton(inText: 'Sign In', onPressed: userSignIn),
        
                const SizedBox(height: 40),
        
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(thickness: 1, color: Colors.grey[700]),
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
        
                const SizedBox(height: 73),
        
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No account? ', 
                        style: TextStyle(color: Colors.grey[600])
                      ),
                      GestureDetector(
                        onTap: widget.onSignUpTap,
                        child: Text('Sign Up!', 
                          style: TextStyle(color: Colors.lightBlue.shade300, fontWeight: FontWeight.bold)
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}