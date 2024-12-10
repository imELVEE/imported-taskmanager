import 'package:flutter/material.dart';
import 'package:planner_app/classes/project_assignment.dart';
import 'package:planner_app/classes/task_assignment.dart';
import 'package:planner_app/pages/login.dart';
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/calendar.dart';
import 'package:planner_app/pages/support.dart';
import 'package:planner_app/pages/task.dart';
import 'package:planner_app/widgets/project_form.dart';
import 'package:planner_app/widgets/task_form.dart';
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
      id: '1',
      createDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(hours: 24)),
      subject: 'Flutter Project',
      notes: 'Do Mobile App',
    ),
    ProjectAssignment(
      id: '2',
      createDate: DateTime.now().subtract(const Duration(hours: 8)),
      dueDate: DateTime.now().add(const Duration(hours: 36)),
      subject: 'Some Project 2',
    ),
    ProjectAssignment(
      id: '3',
      createDate: DateTime.now().subtract(const Duration(hours: 39)),
      dueDate: DateTime.now().add(const Duration(hours: 12)),
      subject: 'Some Project 3',
      completed: true,
      notes: 'Do Something.',
    ),
  ];

  List<TaskAssignment> allTasks = [
    TaskAssignment(
        id: '14',
        createDate: DateTime.now(),
        subject: 'subtask under prj',
        parentId: '1',
    )
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: _topAppBar(),

      body: ProjectsList(
        projects: projects,
        allTasks: allTasks,
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

        onAddTask: _addTaskToProject,
        onToggleTaskCompletion: _toggleTaskCompletion,
        onEditTask: _editTask,
        onDeleteTask: _deleteTask,
        onToggleProjectCompletion: _toggleProjectCompletion,
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

  void _toggleProjectCompletion(ProjectAssignment project, bool? value) {
    setState(() {
      final pIndex = projects.indexWhere((p) => p.id == project.id);
      if (pIndex != -1) {
        projects[pIndex].completed = value ?? false;
        // If you want to also propagate completion state to all tasks of this project:
        _setProjectTasksCompletion(project.id, value ?? false);
      }
    });
  }

  void _setProjectTasksCompletion(String projectId, bool completed) {
    // Find all tasks directly under this project
    final projectTasks = allTasks.where((t) => t.parentId == projectId).toList();
    for (var task in projectTasks) {
      final index = allTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        allTasks[index] = allTasks[index].copyWith(completed: completed);
        _setSubtasksCompletion(allTasks[index].id, completed);
      }
    }
  }

  void _addTaskToProject(ProjectAssignment project) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskForm(
          onSave: (newTask) {
            setState(() {
              newTask.parentId = project.id;
              allTasks.add(newTask);
            });
          },
        );
      },
    );
  }

  // Toggle top-level task completion (and optionally its subtasks)
  void _toggleTaskCompletion(TaskAssignment task, bool? value) {
    setState(() {
      final index = allTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        allTasks[index] = allTasks[index].copyWith(completed: value ?? false);
        _setSubtasksCompletion(allTasks[index].id, value ?? false);
      }
    });
  }

  void _setSubtasksCompletion(String parentId, bool completed) {
    final childTasks = allTasks.where((t) => t.parentId == parentId).toList();
    for (var child in childTasks) {
      final index = allTasks.indexWhere((t) => t.id == child.id);
      if (index != -1) {
        allTasks[index] = allTasks[index].copyWith(completed: completed);
        _setSubtasksCompletion(allTasks[index].id, completed);
      }
    }
  }

  // Edit a top-level task or subtask
  void _editTask(TaskAssignment task) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskForm(
          task: task,
          onSave: (updatedTask) {
            setState(() {
              final index = allTasks.indexWhere((t) => t.id == updatedTask.id);
              if (index != -1) {
                allTasks[index] = updatedTask;
              }
            });
          },
        );
      },
    );
  }

  // Delete a top-level task
  void _deleteTask(TaskAssignment taskToDelete) {
    setState(() {
      allTasks.removeWhere((t) => t.id == taskToDelete.id);
      _removeAllDescendants(taskToDelete.id);
    });
  }

  void _removeAllDescendants(String parentId) {
    final children = allTasks.where((t) => t.parentId == parentId).toList();
    for (var child in children) {
      allTasks.removeWhere((t) => t.id == child.id);
      _removeAllDescendants(child.id);
    }
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
  void _projectPageRoute(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProjectPage())
    );
  }
  void _taskPageRoute(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskPage())
    );
  }
}