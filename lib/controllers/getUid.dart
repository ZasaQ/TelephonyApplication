import 'package:cloud_firestore/cloud_firestore.dart';

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