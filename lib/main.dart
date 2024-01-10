import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:telephon_application/pages/about_page.dart';
import 'package:telephon_application/pages/delete.dart';
import 'package:telephon_application/pages/homepage.dart';
import 'package:telephon_application/pages/login.dart';
import 'package:telephon_application/pages/new_chat.dart';
import 'package:telephon_application/pages/new_contact.dart';
import 'package:telephon_application/pages/messages.dart';
import 'package:telephon_application/pages/new_password.dart';
import 'package:telephon_application/pages/new_username.dart';
import 'package:telephon_application/pages/settingspage.dart';
import 'package:telephon_application/services/authentication.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telephony Application',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue.shade300)),
      debugShowCheckedModeBanner: false,
      home: AuthenticationPage(),
      routes: {
        '/secondpage' : (context) => MessagesPage(),
        '/homepage' : (context) => HomePage(),
        '/settingspage' : (context) => SettingsPage(),
        '/add' : (context) => NewContact(),
        '/aboutpage' : (context) => AboutPage(),
        '/newPassword' : (context) => NewPassword(),
        '/newUsername' : (context) => NewUsername(),
        '/newChat' : (context) => NewChat(),
        '/deletePage' : (context) => Delete(),
      },
    );
  }
}