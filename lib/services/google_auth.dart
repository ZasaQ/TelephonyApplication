import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telephon_application/services/utils.dart';

class GoogleAuth {
  Future authenticateUser() async {
    await signInWithGoogle().then(
      (UserCredential userCredential) async {
        if (userCredential.user?.uid != null) {
          await userExists(uid: userCredential.user!.uid).then(
            (exists) async {
              if (exists) {
                FirebaseMessaging.instance.getToken().then(
                  (token) async {
                    await usersCollection.doc(userCredential.user!.uid).update(
                      {
                        'token': token,
                      },
                    );
                  },
                );
              } else {
                await createUser(userCredential: userCredential);
              }
            },
          );
        }
      },
    );
  }

  Future<UserCredential> signInWithGoogle( ) async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuthentication = await gUser!.authentication;

    final gCredential = GoogleAuthProvider.credential(
      accessToken: gAuthentication.accessToken,
      idToken: gAuthentication.idToken
    );

    return await FirebaseAuth.instance.signInWithCredential(gCredential);
  }

  Future<bool> createUser({required UserCredential userCredential}) async {
    bool created = false;
    await FirebaseMessaging.instance.getToken().then(
      (token) async {
        await usersCollection.doc(userCredential.user?.uid).set(
          {
            'uid': userCredential.user?.uid,
            'name': userCredential.user?.displayName,
            'email': userCredential.user?.email,
            'token': token,
          },
        ).then((value) => created = true);
      },
    );
    return created;
  }

  Future<bool> userExists({required String uid}) async {
    bool exists = false;
    await usersCollection.where('uid', isEqualTo: uid).get().then(
      (user) {
        exists = user.docs.isEmpty ? false : true;
      },
    );
    return exists;
  }
}