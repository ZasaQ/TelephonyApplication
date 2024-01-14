import 'package:flutter/material.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("about page"),
      ),
      body: Center(
        child: ListView(
          children: [
            Image(
              image: AssetImage('lib/images/politechnika-krakowska-logo.png'), 
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("System Telefonii Komórkowej",style:TextStyle(fontSize: 20,color:Colors.lightBlue),),
                  Text("Przygotowali:",style:TextStyle(fontSize:16)),
                ],
              ),
            ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      maxRadius: 30,
                      child: Text("J",style: TextStyle(fontSize: 20),), //first letter of username
                    ),
                    title: Text("Jan Kubowicz"),
                    subtitle: Text("jan.kubowicz@admin.student.pk.edu.pl"),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      maxRadius: 30,
                      child: Text("S",style: TextStyle(fontSize: 20),), //first letter of username
                    ),
                    title: Text("Szymon Adamkiewicz"),
                    subtitle: Text("szymon.adamkiewicz@student.pk.edu.pl"),
                  )
                ],
              ),
            ),
        
      
    );
  }
}