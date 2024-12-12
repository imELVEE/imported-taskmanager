import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planner_app/authentication/email.dart'; // Assuming this is the path for EmailAuth class
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/login.dart'; // Login page after registration
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> registerUser() async {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;
    if (_fireAuth.currentUser != null) {
      final url = Uri.parse('https://planner-appimage-823612132472.us-central1.run.app/register');
      try {
        final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': _fireAuth.currentUser?.email,
              'name': _fireAuth.currentUser?.displayName ?? _fireAuth.currentUser?.email,
              'password': 'password',
              'username' : _fireAuth.currentUser?.displayName ?? _fireAuth.currentUser?.email,
              'userTimeZone': 4
            })
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonMap = jsonDecode(response.body);
          print('Register5: Registered User! Responds: ${jsonMap['message']}');
        } else {
          print('Register5: Failed to register user. Status code: ${response.statusCode} \nResponds: ${response.body}');
        }
      } catch (e) {
        print('Register5: Error: $e');
      }
    }
  }

  // Function to handle user registration
  Future<void> _userSignUp() async {
    String info = await EmailAuth().userRegister(
      email: emailController.text,
      password: passwordController.text,
    );
    // Display a SnackBar with the result
    if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(info),
        backgroundColor:  const Color.fromARGB(119, 144, 196, 255),
        ),
    );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter Your email and Password"),
        backgroundColor:Color.fromARGB(119, 144, 196, 255),),
    );
    }

    // Clear the text fields after registration
    emailController.clear();
    passwordController.clear();

    // If registration is successful, navigate to Login page
    if (info == "Registration Successful") {
      await registerUser();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
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
        "Planner App Register",
        style: TextStyle(color: Colors.white),
      ),
    ),
    backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          // Close keyboard when clicking on blank area
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'lib/assets/plannerlogo.jpg',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 5),
                const Text(
                  "Register Page",
                  style: TextStyle(
                    color: Color.fromARGB(179, 3, 64, 113),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
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
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Your Email",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _userSignUp(); // Call the user registration method
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Colors.white,
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Go Back To Login Page",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
