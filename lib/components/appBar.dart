
import 'package:flutter/material.dart';
import 'package:telephon_application/controllers/getUid.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String currentUser;
  const MainAppBar({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                child: Icon(Icons.flutter_dash),
              )
            ),
            Text("AppName"),
          ],
        ),
        actions: [
          IconButton(onPressed: (){ userSignOut(currentUser);}, icon: Icon(Icons.logout, color: Colors.black,)),
        ],
        
      );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

