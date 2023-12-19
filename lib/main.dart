import 'package:flutter/material.dart';
import 'package:telephon_application/pages/first_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:telephon_application/pages/homepage.dart';
import 'package:telephon_application/pages/new_contact.dart';
import 'package:telephon_application/pages/profilepage.dart';
import 'package:telephon_application/pages/settingspage.dart';
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
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
      routes: {
        '/secondpage' : (context) => ProfilePage(),
        '/homepage' : (context) => HomePage(),
        '/settingspage' : (context) => SettingsPage(),
        '/add' : (context) => NewContact(),
      },
    );
  }
}