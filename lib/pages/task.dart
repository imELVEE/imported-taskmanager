import 'package:flutter/material.dart';
import 'package:planner_app/pages/login.dart';
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/calendar.dart';
import 'package:planner_app/pages/project.dart';

class TaskPage extends StatefulWidget{
  const TaskPage({super.key});

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: _topAppBar(),

      body: const Center(
          child: Text(
            'Task Page',
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
      leading: TextButton.icon(
          onPressed: _homePageRoute,
          label: const Icon(Icons.home)
      ),
      backgroundColor: const Color.fromARGB(255, 3, 64, 113),
      title: const Text('Planner App Tasks'),
      actions: <Widget>[
        TextButton(onPressed: _loginPageRoute, child: const Text('LOGIN')),
      ],
    );
  }

  Widget _bottomNavBar(){
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Projects',
        ),
      ],
      onTap: _onTap,
      currentIndex: _currentIndex,
    );
  }

  void _onTap(int index){
    switch(index) {
      case 0:
        _calendarPageRoute();
        break;
      case 1:
        break;
      case 2:
        _projectPageRoute();
        break;
    }
  }

  void _loginPageRoute(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _homePageRoute(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage())
    );
  }

  void _calendarPageRoute(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CalendarPage()),
    );
  }

  void _projectPageRoute(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProjectPage())
    );
  }
}