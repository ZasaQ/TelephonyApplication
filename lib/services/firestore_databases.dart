import 'package:cloud_firestore/cloud_firestore.dart';

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