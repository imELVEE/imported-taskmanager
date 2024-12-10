import 'package:flutter/material.dart';
import 'package:planner_app/authentication/email.dart';
import 'package:planner_app/authentication/google.dart';
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/logout.dart';
import 'package:planner_app/pages/register.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleAuth _googleAuth = GoogleAuth();

void _googleSignIn() async {
  final user = await _googleAuth.googleSignIn();
  if (user != null) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login Successful with Google!'),
        backgroundColor: Color.fromARGB(119, 144, 196, 255),
      ),
    );

    // Navigate to HomePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } else {
    // Show error message if the login failed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Login failed. Please try again.'),
        backgroundColor: Color.fromARGB(119, 144, 196, 255),
      ),
    );
  }
}

 Future<void> _emailSignIn() async {
  // Check if email and password are not empty
  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter your email and password'),
        backgroundColor: Color.fromARGB(119, 144, 196, 255),
      ),
    );
    return; 
  }

  String info = await EmailAuth().signIn( // Sign in using email and password
    email: emailController.text,
    password: passwordController.text,
  );

  // Clear the text fields sign-in
  emailController.clear();
  passwordController.clear();

  // Show the result of the sign-in attempt
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(info),
      backgroundColor: const Color.fromARGB(119, 144, 196, 255),
    ),
  );

  // Only navigate if sign-in was successful
  if (info == "Login Successfully") {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}


void _forgotPassword() { // Reset Password
  showDialog(
    context: context,
    builder: (context) {
      final TextEditingController resetEmailController = TextEditingController();
      return AlertDialog(
        title: const Text(
          "Forgot Password",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter your email to receive a password reset link in email.",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(color: Colors.black),
              controller: resetEmailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = resetEmailController.text;
              String result = await EmailAuth().sendPasswordResetEmail(email: email); // Send a reset email
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result)),
              );
              Navigator.of(context).pop(); 
            },
            child: const Text(
              "Send Reset Email",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
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
        "Planner App Login",
        style: TextStyle(color: Colors.white),
      ),
    ),
    backgroundColor: Colors.white,
    body: GestureDetector(
      onTap: () {
        // Close keyboard when tapping outside of TextFields
        FocusScope.of(context).unfocus();
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/plannerlogo.jpg',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                "Email",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: emailController,
                  obscureText: false, // Don't obscure the email
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Your Email",
                  ),
                ),
              ),
              const Text(
                "Password",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Your Password",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton( // Register account
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register()),
                  );
                },
                child: const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _forgotPassword();
                },
                child: const Text(
                  "Forgot Email Password?",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Transform.scale(
                scale: 1.2,
                child: SignInButton(
                  Buttons.google,
                  text: "Sign In Using Google", // Sign In using google
                  onPressed: _googleSignIn,
                ),
              ),
              const SizedBox(height: 15),
              Transform.scale(
                scale: 1.2,
                child: SignInButton(
                  Buttons.email,
                  text: "Sign In Using Email",
                  onPressed: _emailSignIn, // Sign In using email
                ),
              ),
              const SizedBox(height: 15),
              Transform.scale(
                scale: 1.2,
                child: SignInButton(
                  Buttons.twitter,
                  text: "Sign In Using Twitter",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogOutPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, 
                    side: BorderSide(color: Colors.white), // Set border color to white
                  ),
                  elevation: 0, 
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0), // Adjust padding for rectangular shape
                ),
                child: const Text( // Navigate to sign out option
                  "Sign Out Option",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue, 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}