import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn {
 final FirebaseAuth _auth = FirebaseAuth.instance;
 Future<void> signInWithGoogle() async {
   // Create a new provider
   GoogleAuthProvider googleProvider = GoogleAuthProvider();
   googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
   googleProvider.setCustomParameters({
     'prompt': "select_account"
   });
   // Once signed in, return the UserCredential
   await FirebaseAuth.instance.signInWithRedirect(googleProvider);
   // Or use signInWithRedirect
   // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
 }
   // Method to handle the redirect result
  Future<UserCredential?> handleRedirectResult() async {
    try {
      // After the redirect, get the result
      final UserCredential userCredential = await FirebaseAuth.instance.getRedirectResult();
      return userCredential;
    } catch (e) {
      print('Error handling redirect result: $e');
      return null; // Handle errors appropriately
    }
  }
 Future<void> logout() async {
   await _auth.signOut();
   await GoogleSignIn().signOut();
 }
}
