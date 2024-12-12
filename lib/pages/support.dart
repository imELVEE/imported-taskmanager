import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:planner_app/pages/Reminder.dart';
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/login.dart';
import 'package:planner_app/pages/logout.dart';
import 'package:planner_app/pages/project.dart';
import 'package:planner_app/pages/task.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  SupportPageState createState() => SupportPageState();
}

class SupportPageState extends State<SupportPage> {
  int _currentIndex = 0;
  User? _currentUser;
   void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _loginPageRoute,  // Go to loginpage on double tap
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _topAppBar(),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot Email/Password?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(206, 3, 64, 113),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Click "Forgot Email Password?" on login page to reset your password.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(179, 3, 64, 113),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Go to Login Page?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(206, 3, 64, 113),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Click on Login on the top right corner or double tap the screen',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(179, 3, 64, 113),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "Didn't receive Password reset email?",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(206, 3, 64, 113),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Please check to make sure you enter the correct email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(179, 3, 64, 113),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                 Text(
                  'Need Help?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(206, 3, 64, 113),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Contact us at: 718-212-8923',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(179, 3, 64, 113),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _bottomNavBar(),
      ),
    );
  }

  PreferredSizeWidget _topAppBar() {
    return AppBar(
      leading: TextButton.icon(
        onPressed: _homePageRoute,
        label: const Icon(Icons.home),
      ),
      backgroundColor: const Color.fromARGB(255, 3, 64, 113),
      title: const Text('Planner App Support'),
    actions: <Widget>[
        if (_currentUser != null) ...[
        TextButton(onPressed: _logOutPageRoute, child: const Text('LOGOUT')),
      ]
      else  ...[
          TextButton(onPressed: _loginPageRoute, child: const Text('LOGIN')),
        ]
    ],
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, 
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Projects',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.question_mark_rounded),
          label: 'Support',
        ),
      ],
      onTap: _onTap,
      currentIndex: _currentIndex,
    );
  }

  void _onTap(int index) {
    switch (index) {
      case 0:
        _taskPageRoute();
        break;
      case 1:
        _projectPageRoute();
        break;
      case 2:
        _supportPageRoute();
        break;
    }
  }
   void _supportPageRoute() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SupportPage()),
    );
  }
  void _loginPageRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
  void _taskPageRoute() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TaskPage()),
    );
  }
   void _projectPageRoute() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProjectPage()),
    );
  }

  void _homePageRoute() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
  }
    void _logOutPageRoute() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogOutPage()),
    );
  }
}
