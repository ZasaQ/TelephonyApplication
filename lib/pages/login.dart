import 'package:flutter/material.dart';
import 'package:telephon_application/components/lr_text_field.dart';
import 'package:telephon_application/components/lr_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //Login and Password text field controllers
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  void userSignIn() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
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

              // Login text field
              LRTextField(
                controller: loginController, 
                inHintText: 'Login', 
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
                    style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)
                  )
                ],
              )
              //Center(child: Text('No Account? Sign Up!', style: TextStyle(color: Colors.grey[600])))
            ],
          ),
        ),
      )
    );
  }
}