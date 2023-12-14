// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
           Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),

            padding: EdgeInsets.all(25),
            child: Text("Kontakt1", 
              style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
              color: Colors.green[400],
              borderRadius: BorderRadius.circular(20),
              ),
              child: Text("Kontakt1", 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
              ),
            ),
            ),
         
          Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
              color: Colors.green[200],
              borderRadius: BorderRadius.circular(20),
              ),
              child: Text("Kontakt1", 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
              ),
            ),
            ),
          
          ],
      ),
    );
  }
}
