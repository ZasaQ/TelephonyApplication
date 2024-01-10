import 'package:flutter/material.dart';
import 'package:telephon_application/components/lr_button.dart';
import 'package:telephon_application/controllers/crud_services.dart';

class Delete extends StatefulWidget {
  const Delete({super.key});

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete account"),
        
      ),
      body: Center(
        child: Column(
          children: [
            Text("If you click the button the changes will be irreversible"),
            LRButton(
              inText: "Delete account",
              onPressed: (){
                CrudServices().deleteAccount();
              },
            ),
          ],
        ),
      ),
    );
  }
}