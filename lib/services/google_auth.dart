import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telephon_application/controllers/crud_services.dart';

class GoogleAuth {
  signInWithGoogle( ) async {
    final CrudServices _crudServices = CrudServices();

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuthentication = await gUser!.authentication;

    final gCredential = GoogleAuthProvider.credential(
      accessToken: gAuthentication.accessToken,
      idToken: gAuthentication.idToken
    );

    //String name = gUser.email.substring(0, gUser.email.indexOf('@'));
    //_crudServices.addUser(gUser.email, name, gCredential.idToken.toString());

    return await FirebaseAuth.instance.signInWithCredential(gCredential);
  }
}