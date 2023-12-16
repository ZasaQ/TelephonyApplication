import 'package:flutter/material.dart';
import 'package:telephon_application/pages/first_page.dart';
import 'package:telephon_application/pages/homepage.dart';
import 'package:telephon_application/pages/profilepage.dart';
import 'package:telephon_application/pages/settingspage.dart';
import 'pages/login.dart';


int xd=0;
void main() => runApp(const MyApp());

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
      },
    );
  }
}