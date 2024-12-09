import 'package:flutter/material.dart';
import 'package:planner_app/classes/task_assignment.dart';
import 'package:planner_app/pages/login.dart';
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/project.dart';
import 'package:planner_app/pages/support.dart';
import 'package:planner_app/widgets/task_form.dart';
import 'package:planner_app/widgets/task_list.dart';

class TaskPage extends StatefulWidget{
  const TaskPage({super.key});

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  int _currentIndex = 0;
  List<TaskAssignment> tasks = [
    TaskAssignment(
      id: 4,
      createDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(hours: 24)),
      subject: 'Drink Water',
      notes: 'Fill glass.',
    ),
    TaskAssignment(
      id: 5,
      createDate: DateTime.now().subtract(const Duration(hours: 8)),
      dueDate: DateTime.now().add(const Duration(hours: 36)),
      subject: 'Some Task 2',
    ),
    TaskAssignment(
      id: 6,
      createDate: DateTime.now().subtract(const Duration(hours: 39)),
      dueDate: DateTime.now().add(const Duration(hours: 12)),
      subject: 'Finish tasks class/widget',
      completed: true,
      notes: 'More to add',
    ),
    //Subtasks
    TaskAssignment(
      id: 7,
      createDate: DateTime.now().subtract(const Duration(hours: 39)),
      dueDate: DateTime.now().add(const Duration(hours: 12)),
      subject: 'Fill Water Glass',
      notes: 'blah blah',
      completed: true,
      parentId: 4
    ),
  ];

  @override
  Widget build(BuildContext context){
    final topLevelTasks = tasks.where((t) => t.parentId == null).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: _topAppBar(),

      body: TasksList(
        tasks: topLevelTasks,
        allTasks: tasks,
        onTaskUpdate: (task) {
          showDialog(
            context: context,
            builder: (context) {
              return TaskForm(
                task: task,
                onSave: _updateTask,
              );
            },
          );
        },
        onDelete: _deleteTask,
        onAddSubtask: _addSubtask,
        onToggleSubtask: _toggleTaskCompletion,
        onEditSubtask: _editSubtask,
        onDeleteSubtask: _deleteSubtask,
        onToggleTaskCompletion: _toggleTaskCompletion,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 23, 84, 140),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return TaskForm(
                onSave: _addTask,
              );
            },
          );
        }, // Open form to add new task
        child: Icon(Icons.add),
      ),

      bottomNavigationBar: _bottomNavBar(),
    );
  }

  // Add new task to the list
  void _addTask(TaskAssignment newTask) {
    setState(() {
      tasks.add(newTask);
    });
  }

  // Update existing task
  void _updateTask(TaskAssignment updatedTask) {
    setState(() {
      final index = tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
    });
  }

  void _deleteTask(TaskAssignment taskToDelete) {
    setState(() {
      tasks.removeWhere((task) => task.id == taskToDelete.id);
    });
  }

  void _toggleTaskCompletion(TaskAssignment task, bool? value) {
    setState(() {
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = TaskAssignment(
          id: tasks[index].id,
          createDate: tasks[index].createDate,
          dueDate: tasks[index].dueDate,
          subject: tasks[index].subject,
          notes: tasks[index].notes,
          completed: value ?? false,
          parentId: tasks[index].parentId,
        );
      }

      _setSubtasksCompletion(tasks[index].id, value ?? false);
    });
  }

  void _setSubtasksCompletion(int parentId, bool completed) {
    // Find all tasks whose parentId matches parentId
    final childTasks = tasks.where((t) => t.parentId == parentId).toList();

    for (final child in childTasks) {
      // Update this child's completion
      final index = tasks.indexWhere((task) => task.id == child.id);
      if (index != -1) {
        tasks[index] = TaskAssignment(
          id: tasks[index].id,
          createDate: tasks[index].createDate,
          dueDate: tasks[index].dueDate,
          subject: tasks[index].subject,
          notes: tasks[index].notes,
          completed: completed,
          parentId: tasks[index].parentId,
        );
      }

      // Recursively update this child's subtasks
      _setSubtasksCompletion(child.id, completed);
    }
  }


  // Add a subtask to a parent task
  void _addSubtask(TaskAssignment parentTask) {
    // Show a TaskForm and set the parentId of the new task to parentTask.id
    showDialog(
      context: context,
      builder: (context) {
        return TaskForm(
          onSave: (newSubtask) {
            setState(() {
              // Assign parentId to link it as a subtask
              newSubtask.parentId = parentTask.id;
              tasks.add(newSubtask);
            });
          },
        );
      },
    );
  }

  // Edit an existing subtask
  void _editSubtask(TaskAssignment subtask) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskForm(
          task: subtask,
          onSave: _updateTask,
        );
      },
    );
  }

  // Delete a subtask
  void _deleteSubtask(TaskAssignment subtaskToDelete) {
    setState(() {
      tasks.removeWhere((task) => task.id == subtaskToDelete.id);
    });
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