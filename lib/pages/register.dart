import 'package:flutter/material.dart';
import 'package:planner_app/pages/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () { // Close keyboard when click on blanck
          FocusScope.of(context).unfocus();
        },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Aligns items from the start
            crossAxisAlignment: CrossAxisAlignment.center, // Center alignment
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
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Your Email",
                  ),
                ),
              ),
              const SizedBox(height: 10), // Space between Email and Password fields
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
              const SizedBox(height: 20), // Space before buttons
              ElevatedButton(
                onPressed: () {
                  // Add registration functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10), // Space between buttons
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
              const SizedBox(height: 20), // Space after buttons
            ],
          ),
        ),
      ),
      )
    );
  }
}
