import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Handle Google Sign-In
Future<User?> googleSignIn() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final String? idToken = await user.getIdToken();
        // print("Google User ID Token: $idToken");
      }
      return user;
    }
  } catch (e) {
    print("Google Sign-In Error: $e");
  }
  return null;
}


  // Handle Google Sign-Out
  Future<void> googleSignOut() async {
      await _auth.signOut(); // Sign out from Firebase
      await _googleSignIn.signOut(); // Sign out from Google
  }
}
