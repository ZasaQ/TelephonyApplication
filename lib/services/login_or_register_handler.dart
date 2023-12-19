import "package:flutter/material.dart";
import "package:telephon_application/pages/login.dart";
import "package:telephon_application/pages/register.dart";

class LoginOrRegisterHandler extends StatefulWidget {
  const LoginOrRegisterHandler({super.key});

  @override
  State<LoginOrRegisterHandler> createState() => _LoginOrRegisterHandlerState();
}

class _LoginOrRegisterHandlerState extends State<LoginOrRegisterHandler> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onSignUpTap: togglePages);
    } else {
      return RegisterPage(onSignInTap: togglePages);
    }
  }
}