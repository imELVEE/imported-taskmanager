import 'package:flutter/material.dart';
import 'package:planner_app/classes/project_assignment.dart';
import 'package:planner_app/pages/login.dart';
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/calendar.dart';
import 'package:planner_app/pages/task.dart';
import 'package:planner_app/widgets/project_form.dart';
import '../widgets/projects_list.dart';

class ProjectPage extends StatefulWidget{
  const ProjectPage({super.key});

  @override
  ProjectPageState createState() => ProjectPageState();
}

class ProjectPageState extends State<ProjectPage> {
  int _currentIndex = 0;
  ProjectsList projectList = ProjectsList(key: ValueKey('projectsList'));

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: _topAppBar(),

      body: ProjectsList(key: ValueKey('projectsList')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 23, 84, 140),
        onPressed: () => _showProjectForm(), // Open form to add new task
        child: Icon(
            Icons.add,
        ),
      ),

      bottomNavigationBar: _bottomNavBar(),
    );
  }

  // Function to handle saving a task (either add or edit)
  void _saveProject(ProjectAssignment project) {
    setState(() {
      // If the task has an ID, we update the task, otherwise, we add a new task
      if (project.id == null) {
        // If task has no id, it's a new task
        projectList.projects.add(project);
      } else {
        // If task has an id, we update it
        int index = projectList.projects.indexWhere((p) => p.id == project.id);
        if (index != -1) {
         projectList.projects[index] = project;
        }
      }
    });
  }

  // Function to show the dialog for adding/editing a task
  void _showProjectForm({ProjectAssignment? project}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProjectForm(
          project: project,
          onSave: _saveProject,
        );
      },
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