import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  TextEditingController _searchController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FocusNode _searchFocusNode = FocusNode();
  var searchName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            stream: FirebaseFirestore.instance
            .collection('Calls')
            .where(Filter.or(Filter('caller', isEqualTo: _auth.currentUser!.email.toString()),Filter('called', isEqualTo: _auth.currentUser!.email.toString())))
            //.startAt([searchName])
            //.endAt([searchName + "\uf8ff"])
            .snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                return Text("Can't upload data");
              }
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(
                  child: Text("loading"),
          
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children:snapshot.data!.docs.map((DocumentSnapshot document){
                    Map<String,dynamic> data= document.data()! as Map<String, dynamic>;
                    if(data['caller'].isNotEmpty&&_auth.currentUser!.email!=data['caller']){
                      print('data loaded');
                      return Container(
                        child: ExpansionTile(
                          leading: Icon(Icons.call_received,color: Colors.red),
                          title:Text(data["caller"],style:TextStyle(fontWeight: FontWeight.w600)),
                          subtitle:Text(data['activationDate'],style:TextStyle(fontWeight: FontWeight.w300)),
                          children: [
                            Row(
                              children: [
                                rejected(data),
                              ],
                            ),

                          ],
                        ),
                      );
                    }else if(data['called'].isNotEmpty&&_auth.currentUser!.email!=data['called']){
                      return Container(
                        child: ExpansionTile(
                          leading: Icon(Icons.call_made,color: Colors.green),
                         title:Text(data["called"],style:TextStyle(fontWeight: FontWeight.w600)),
                          subtitle:Text(data['activationDate'],style:TextStyle(fontWeight: FontWeight.w300)),
                          children: [
                            Row(
                              children: [
                                rejected(data),
                              ],
                            ),

                          ],
                        ),
                      );
                    }
                  }).toList().cast(),
                  
                ),
              );
            }, 
          ), 
    );
  }
  Container rejected(Map<String,dynamic> data){
    if(data['rejected']==false&&data['accepted']==true){
      return Container(
        child: Row(
          children: [
            Icon(Icons.phone),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Call accepted",
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,)
              ),
            ),
          ],
        ),
      );
    }else if(data['rejected']==true){
      return Container(
        child: Row(
          children: [
            Icon(Icons.call_end),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Call rejected",
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,)
              ),
            ),
          ],
        ),
      );
    }else if(data['connected']==false){
      return Container(
        child: Row(
          children: [
            Icon(Icons.one_x_mobiledata),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Couldn't connect",
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,)
              ),
            ),
          ],
        ),
      );
    }
    else{
      return Container(
        child: Row(
          children: [
            Icon(Icons.call_missed),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("User didn't answer",
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,)
              ),
            ),
          ],
        ),
      );
    }
  }
  
}