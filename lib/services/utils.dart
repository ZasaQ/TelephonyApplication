import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

CollectionReference callsCollection = FirebaseFirestore.instance.collection("Calls");

CollectionReference usersCollection = FirebaseFirestore.instance.collection("Users");

Stream<List<DocumentSnapshot>> usersData() async* {
  List<DocumentSnapshot> users = [];
  await usersCollection.get().then(
    (value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          users.add(element);
        }
      }
    },
  );

  yield users;
}

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