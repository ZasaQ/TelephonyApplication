import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  signInWithGoogle( ) async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuthentication = await gUser!.authentication;

    final gCredential = GoogleAuthProvider.credential(
      accessToken: gAuthentication.accessToken,
      idToken: gAuthentication.idToken
    );

    return await FirebaseAuth.instance.signInWithCredential(gCredential);
  }
}