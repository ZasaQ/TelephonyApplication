import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getUserIdByUid(String currentUserId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: currentUserId).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user ID by UID: $e');
      return null;
    }
 }
void userSignOut(String currentUser) async{
    try{
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: currentUser).get();
        String tokenValue = FirebaseMessaging.instance.getToken().toString();
        await FirebaseFirestore.instance.collection("Users").doc(querySnapshot.docs.first.id).update(
            {
              'token': "",
            },
        );
        print("token is empty");
        FirebaseAuth.instance.signOut();
    }catch (e){
      print("Can't delete token value");
}} 