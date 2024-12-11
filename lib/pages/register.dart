import 'package:flutter/material.dart';
import 'package:planner_app/authentication/email.dart'; // Assuming this is the path for EmailAuth class
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/login.dart'; // Login page after registration

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // User registration
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: 100),
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
