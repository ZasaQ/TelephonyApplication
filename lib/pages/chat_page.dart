import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/components/chat_bubble.dart';
import 'package:telephon_application/services/chat/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String userEmail;
  final String usersId;
  const ChatPage({super.key, required this.userEmail, required this.usersId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMsg() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(
        widget.usersId, _messageController.text);

      _messageController.clear();

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userEmail),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.video_call, color: Colors.lightBlue,)),
        ]
      ),
      body: Column(
        children: [
          Expanded(
            child: _messageList(),
          ),

          _messageInput(),
        ],
      ),
    );
  }

  Widget _messageInput(){
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              label: Text('Type message'),
            ),
            obscureText: false,
          ),
        ),
        IconButton(onPressed: sendMsg, icon: Icon(Icons.send)),
      ],
    );
  }

  Widget _messageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var messageAlign = (data['senderId'] == _auth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      padding: EdgeInsets.all(8.0),
      alignment: messageAlign,
      child: Column(
        crossAxisAlignment: (data['senderId'] == _auth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(data['senderEmail'],style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
          ChatBubble(msg: data['message']),
        ],
      ),
    );
  }

  Widget _messageList(){
    return StreamBuilder(
      stream: _chatService.getMessage(widget.usersId, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text('Error${snapshot.error}');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Text('Loading...');
        }
        return ListView(
          children: snapshot.data!.docs.map((document) => _messageItem(document)).toList(),
        );
      },
    );
  }
}