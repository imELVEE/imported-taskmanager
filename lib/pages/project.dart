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
  List<ProjectAssignment> projects = [
    ProjectAssignment(
      id: 1,
      createDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(hours: 24)),
      subject: 'Flutter Project',
      notes: 'Do Mobile App',
    ),
    ProjectAssignment(
      id: 2,
      createDate: DateTime.now().subtract(const Duration(hours: 8)),
      dueDate: DateTime.now().add(const Duration(hours: 36)),
      subject: 'Some Project 2',
    ),
    ProjectAssignment(
      id: 3,
      createDate: DateTime.now().subtract(const Duration(hours: 39)),
      dueDate: DateTime.now().add(const Duration(hours: 12)),
      subject: 'Some Project 3',
      completed: true,
      notes: 'Do Something.',
    ),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: _topAppBar(),

      body: ProjectsList(
        projects: projects,
        onProjectUpdate: (project) {
          showDialog(
            context: context,
            builder: (context) {
              return ProjectForm(
                project: project,
                onSave: _updateProject,
              );
            },
          );
        },
        onDelete: _deleteProject,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 23, 84, 140),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ProjectForm(
                onSave: _addProject,
              );
            },
          );
        }, // Open form to add new task
        child: Icon(Icons.add),
      ),

      bottomNavigationBar: _bottomNavBar(),
    );
  }

  // Add new project to the list
  void _addProject(ProjectAssignment newProject) {
    setState(() {
      projects.add(newProject);
    });
  }

  // Update existing project
  void _updateProject(ProjectAssignment updatedProject) {
    setState(() {
      final index = projects.indexWhere((project) => project.id == updatedProject.id);
      if (index != -1) {
        projects[index] = updatedProject;
      }
    });
  }

  void _deleteProject(ProjectAssignment projectToDelete) {
    setState(() {
      projects.removeWhere((project) => project.id == projectToDelete.id);
    });
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