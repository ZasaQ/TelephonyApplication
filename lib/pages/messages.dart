import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/pages/chat_page.dart';


class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  var searchName = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width*8,80),
            child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width*.9,
                  child: TextFormField(
                    onChanged: (value){
                      setState(() {
                        searchName=value;
                      });
                    },
                    focusNode: _searchFocusNode,
                    controller: _searchController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.grey)
                      ),
                      prefixIcon: Icon(Icons.search),
                      label: Text("Search"),
                      //suffixIcon: _searchController.text.isNotEmpty? IconButton(onPressed: (){_searchController.clear();_searchFocusNode.unfocus();}, icon: Icon(Icons.close)):null,
                    ),
                  ),
              
           ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').orderBy('name').startAt([searchName]).endAt([searchName + "\uf8ff"]).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                return Text("Can't upload data");
              }
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(
                  child: Text("loading"),
          
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: snapshot.data!.docs.map((DocumentSnapshot document){
                  Map<String,dynamic> data= document.data()! as Map<String, dynamic>;
                  if(_auth.currentUser!.email != data['email']){
                    return ListTile(
                      leading:CircleAvatar(child: Text(data["name"][0])), //first letter of contact
                      title:Text(data["name"]),
                      subtitle:Text(data["email"]),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                          userEmail: data['email'],
                          usersId: data['uid'],
                          userName: data["name"],
                        ),));
                        
                      },
                    );
                  }else{
                    return Container();
                  }
                }).toList().cast(),
                ),
                
              );
            }, 
          ),
    );
  }
}