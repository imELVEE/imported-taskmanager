import 'package:flutter/material.dart';
import 'package:planner_app/pages/login.dart';
import 'package:planner_app/pages/support.dart';
// import 'package:planner_app/pages/calendar.dart';
import 'package:planner_app/pages/task.dart';
import 'package:planner_app/pages/project.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: _topAppBar(),

      body: const Center(
          child: Text(
            'Home Page',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(179, 3, 64, 113),
            ),
          )
      ),

      bottomNavigationBar: _bottomNavBar(),
    );
  }

  PreferredSizeWidget _topAppBar(){
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 3, 64, 113),
      title: const Text('Planner App Home'),
      actions: <Widget>[
        TextButton(onPressed: _loginPageRoute, child: const Text('LOGIN')),
      ],
    );
  }

  Widget _bottomNavBar(){
    return BottomNavigationBar(
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

  void _onTap(int index){
    switch(index) {
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

  void _loginPageRoute(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
    void _supportPageRoute(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SupportPage())
    );
  }
  void _taskPageRoute(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskPage())
    );
  }

  void _projectPageRoute(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProjectPage())
    );
  }
}