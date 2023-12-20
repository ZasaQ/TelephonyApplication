// ignore_for_file: prefer_const_constructors, avoid_types_as_parameter_names, non_constant_identifier_names


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/controllers/crud_services.dart';



class HomePage extends StatelessWidget {
   HomePage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/add");
        }, 
        child: Icon(Icons.person_add),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: CrudServices().getContacts(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text("Can't upload data");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: Text("loading"),

            );
          }
          return ListView(
            children:snapshot.data!.docs.map((DocumentSnapshot document){
              Map<String,dynamic> data= document.data()! as Map<String, dynamic>;
              return ExpansionTile(
                leading: CircleAvatar(child: Text(data["name"][0])), //first letter of contact
                title: Text(data["name"]),
                subtitle: Text(data["phoneNumber"]),
                
                children: [
                  ListTile(
                    tileColor: Colors.grey[700] ,
                    titleTextStyle: TextStyle(color: Colors.white),
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text("Zadzwon",style: TextStyle(fontSize: 15)),
                    trailing: IconButton(icon: Icon(Icons.call,color: Colors.white,), onPressed: () {},),
                  ),
                ],
              );

            }).toList().cast(),
          );
        }, 
        /*padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: Column(
          children:[
            searchField(),
            ListTile(
              leading: CircleAvatar(child: Text("T")), //first letter of contact
              title: Text("kontakt"),
              subtitle: Text("123456789"),
              trailing: IconButton(icon: Icon(Icons.call), onPressed: () {},),
            ),
          ,
        ),*/
      
      ),
      );
  }


  

  ListView contactList(){
    return ListView(
        children: [
          ListTile(
            leading: CircleAvatar(child: Text("T")), //first letter of contact
            title: Text("kontakt"),
            subtitle: Text("123456789"),
            trailing: IconButton(icon: Icon(Icons.call), onPressed: () {},),
          ),
        ],
    );
  }
  
  
}
