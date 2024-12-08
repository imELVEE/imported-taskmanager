import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method for user registration
  Future<String> userRegister({required String email, required String password}) async {
    try {
      final UserCredential emailCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = emailCredential.user;
      if (user != null) {
        return "Registration Successful";
      } else {
        return "User creation failed";
      }
    } catch (e) {
      print("Error Occurred: $e");
      return "Error Occurred: ${e.toString()}";
    }
  }

  // Method for user sign-in
Future<String> signIn({required String email, required String password}) async {
  try {
    final UserCredential emailCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final User? user = emailCredential.user;
    if (user != null) {
      final String? idtoken = await user.getIdToken();
      // print("Email ID Token: $token");
      return "Login Successfully";
    } else {
      return "Login failed";
    }
  } catch (e) {
    print("Error Occurred: $e");
    return "Error Occurred: ${e.toString()}";
  }
}


  // Method for user sign-out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("Sign out successfully");
    } catch (e) {
      print("Error Occurred: $e");
    }
  }
  // Method for sending password reset email
  Future<String> sendPasswordResetEmail({required String email}) async {
    try {
      if (email.isEmpty) {
        return "Please enter a valid email.";
      }
      await _auth.sendPasswordResetEmail(email: email);
      return "Password reset email sent successfully! Please check your email";
    } catch (e) {
      return "Error Occurred: ${e.toString()}";
    }
  }

  // Method for handling reset password
  Future<String> confirmPasswordReset({required String newPassword, required String oobCode}) async {
    try {
      await _auth.confirmPasswordReset(
        code: oobCode,
        newPassword: newPassword,
      );
      return "Password reset successfully!";
    } catch (e) {
      return "Error Occurred: ${e.toString()}";
    }
  }
}