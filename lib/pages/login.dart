import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planner_app/pages/calendar.dart';
import 'package:planner_app/pages/planner.dart';
import 'package:planner_app/pages/register.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:planner_app/pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _homePageRoute(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: const Color.fromARGB(255, 3, 64, 113),
      ),
      body: GestureDetector(
        onTap: () { // Close keyboard when click on blanck
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
              const SizedBox(height: 5), 
              const Text(
                "Planner App Login Page",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(179, 3, 64, 113),
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
              TextButton(
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
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CalendarPage()),
                  );
                },
                 style: ElevatedButton.styleFrom(
                    backgroundColor:Colors.white,
                    foregroundColor: Colors.black,
                  ),
                child: const Text(
                  "Login", 
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    )
                  ),
              ),
              const SizedBox(height: 5),
              Transform.scale(
                scale: 1.2,
                child: SignInButton(
                  Buttons.google,
                  text: "Sign In Using Google",
                  onPressed: () {
                     Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Planner()),
                  );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Transform.scale(
                scale: 1.2,
                child: SignInButton(
                  Buttons.microsoft,
                  text: "Sign In Using Microsoft",
                  onPressed: () {
                     Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Planner()),
                  );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}
