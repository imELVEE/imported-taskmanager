import 'package:flutter/material.dart';
import 'package:planner_app/pages/login.dart';
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/calendar.dart';
import 'package:planner_app/pages/task.dart';
import '../widgets/projects_list.dart';

class ProjectPage extends StatefulWidget{
  const ProjectPage({super.key});

  @override
  ProjectPageState createState() => ProjectPageState();
}

class ProjectPageState extends State<ProjectPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: _topAppBar(),

      body: ProjectsList(key: ValueKey('projectsList')),

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
      title: const Text('Planner App Projects'),
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
        _taskPageRoute();
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

  void _taskPageRoute(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskPage())
    );
  }
}