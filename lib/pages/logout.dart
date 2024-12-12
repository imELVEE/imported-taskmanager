import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planner_app/authentication/email.dart';
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/login.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogOutPage extends StatefulWidget {
  const LogOutPage({super.key});

  @override
  State<LogOutPage> createState() => _LogOutPageState();
}

class _LogOutPageState extends State<LogOutPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _facebookSignOut() async {
    try {
      // Check if the user is signed in with email
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is signed in, proceed with sign-out
        await FacebookAuth.instance.logOut();
        await _auth.signOut();
        // Show Snackbar message successful sign-out
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar( 
            content: Text("You have signed out of your Facebook account."),
            backgroundColor:  Color.fromARGB(119, 144, 196, 255),
          ),
        );
        // Navigate back to LoginPage after sign-out
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()), 
        );
      } else {
        // If no user is logged in, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:Text("You are not logged in using facebook."),
            backgroundColor:  Color.fromARGB(119, 144, 196, 255),
          ),
        );
      }
    } catch (e) {
      print("Error during email sign-out: $e");
    }
  }

  // Handle Email Sign-Out
  Future<void> _emailSignOut() async {
    try {
      // Check if the user is signed in with email
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is signed in, proceed with sign-out
        await EmailAuth().signOut();
        // Show Snackbar message successful sign-out
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You have signed out of your email account."),
            backgroundColor:  Color.fromARGB(119, 144, 196, 255),
          ),
        );
        // Navigate back to LoginPage after sign-out
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()), 
        );
      } else {
        // If no user is logged in, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:Text("You are not logged in using email."),
            backgroundColor:  Color.fromARGB(119, 144, 196, 255),
          ),
        );
      }
    } catch (e) {
      print("Error during email sign-out: $e");
    }
  }
  // Handle Google Sign-Out
  Future<void> _googleSignOut() async {
    try {
      // Check if the user is signed in
      User? user = _auth.currentUser;
      
      if (user != null) {
        // User is logged in, proceed with sign-out
        await _auth.signOut();
        await _googleSignIn.signOut();
        // Show Snackbar message after successful sign-out
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You have signed out of your Google account."),
            backgroundColor:  Color.fromARGB(119, 144, 196, 255),
          ),
        );
        // Navigate to HomePage after sign-out
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), 
        );
      } else {
        // If no user is logged in, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You are not logged in using Google."),
            backgroundColor:  Color.fromARGB(119, 144, 196, 255),
          ),
        );
      }
    } catch (e) {
      print("Error during Google sign-out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.home),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
      ),
      backgroundColor: const Color.fromARGB(255, 3, 64, 113),
      title: const Text(
        "Planner App Logout",
        style: TextStyle(color: Colors.white),
      ),
    ),
    backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            // Email Logout Button
            Transform.scale(
              scale: 1.2,
              child: SignInButton(
                Buttons.email,
                text: "Email Sign Out",
                onPressed: _emailSignOut, 
              ),
            ),
            const SizedBox(height: 15),
            
            // Google Logout Button
            Transform.scale(
              scale: 1.2,
              child: SignInButton(
                Buttons.google,
                text: "Google Sign Out",
                onPressed: _googleSignOut,
              ),
            ),
            const SizedBox(height: 15),
            
            // Twitter Logout Button
            Transform.scale(
              scale: 1.2,
              child: SignInButton(
                Buttons.facebook,
                text: "Facebook Sign Out",
                onPressed:(){
                  _facebookSignOut();
                } 
              ),
            ),
            const SizedBox(height: 15),
            
            // Go Back to Login Page Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, 
                  side: BorderSide(color: Colors.blue), 
                ),
                elevation: 0, // Remove shadow
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40), 
              ),
              child: const Text(
                "Go Back To Login Page",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
