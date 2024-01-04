 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephon_application/models/message.dart';

class ChatService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Send message
  Future<void> sendMessage(String receiverId, String message) async{
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMsg = Message(senderId: currentUserId, senderEmail: currentUserEmail, receiverId: receiverId, message: message, timestamp: timestamp);
  
    List<String> users = [currentUserId, receiverId];
    users.sort();
    String chatId = users.join("_");

    await _firestore.collection('chat_rooms').doc(chatId).collection('messages').add(newMsg.toMap());
  }
  //Get messages
  Stream<QuerySnapshot> getMessage(String userId, String chatUserId){
    List<String> users = [userId,chatUserId];
    users.sort();
    String chatId = users.join("_");
    return _firestore.collection('chat_rooms').doc(chatId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }
}