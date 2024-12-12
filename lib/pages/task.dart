import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planner_app/classes/task_assignment.dart';
import 'package:planner_app/pages/login.dart';
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/project.dart';
import 'package:planner_app/pages/support.dart';
import 'package:planner_app/widgets/task_form.dart';
import 'package:planner_app/widgets/task_list.dart';
import 'package:http/http.dart' as http;

class TaskPage extends StatefulWidget{
  const TaskPage({super.key});

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<TaskAssignment> tasks = []; // State variable to store tasks

  @override
  void initState() {
    super.initState();
    _fetchAndSetTasks(); // Fetch tasks on widget initialization
  }

  List<TaskAssignment> parseTasksFromJson(String jsonString) {
    try {
      final dynamic outerDecoded = jsonDecode(jsonString);
      final List<dynamic> jsonData = outerDecoded is String
          ? jsonDecode(outerDecoded)
          : outerDecoded;

      return jsonData.map((item) {
        // Map only the relevant fields
        final map = item as Map<String, dynamic>;
        return TaskAssignment(
          id: map['assignment_id'] ?? '',
          createDate: DateTime.tryParse(map['create_date'] ?? '') ?? DateTime.now(),
          dueDate: map['due_date'] != null ? DateTime.tryParse(map['due_date']) : null,
          subject: map['subject'] ?? 'No Subject',
          notes: map['notes'] ?? '',
          completed: map['completed'] ?? false, // Defaulting as there's no "completed" field
          completeDate: map['completed_date'], // Defaulting as there's no "complete_date" field
          parentId: null, // Defaulting as there's no "parentId" field
        );
      }).toList();
    }
    catch (e) {
      print('Task5: Error parsing JSON: $e');
      return [];
    }
  }

  Future<void> _fetchAndSetTasks() async {
    try {
      final fetchedTasks = await fetchTasks();
      setState(() {
        tasks = fetchedTasks; // Update the state variable with fetched tasks
      });
    } catch (e) {
      // Handle errors if needed
      print('Task55: Error fetching tasks: $e');
    }
  }

  Future<List<TaskAssignment>> fetchTasks() async {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;

    if (_fireAuth.currentUser != null) {
      final url = Uri.parse('https://planner-appimage-823612132472.us-central1.run.app/assignments');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _fireAuth.currentUser?.email,
            'assignment_type': 'Tasks',
          }),
        );

        //print('Task5: ${response.body}');
        if (response.statusCode == 200) {
          return parseTasksFromJson(response.body);
        } else {
          throw Exception('Task5: Failed to fetch tasks. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Task5: Error fetching tasks: $e');
      }
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: _topAppBar(),

      body:  _auth.currentUser == null
      ? const Center(
        child: Text(
          "Please log in to view tasks.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      )
      : FutureBuilder<List<TaskAssignment>>(
        future: fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while waiting for the tasks
            return const Center(child: CircularProgressIndicator(color: Colors.blue));
          } else if (snapshot.hasError) {
            // Show an error message if an error occurs
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            final tasks = snapshot.data!;
            if (tasks.isEmpty) {
              // Handle the case where tasks are loaded but the list is empty
              return const Center(
                child: Text(
                  "No tasks available.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            final topLevelTasks =
            tasks.where((t) => t.parentId == null).toList();

            return TasksList(
              tasks: topLevelTasks,
              allTasks: tasks,
              onTaskUpdate: _updateTaskInformation,
              onDelete: _deleteTask,
              onAddSubtask: _addSubtask,
              onToggleSubtask: _toggleTaskCompletion,
              onEditSubtask: _editSubtask,
              onDeleteSubtask: _deleteSubtask,
              onToggleTaskCompletion: _toggleTaskCompletion,
            );
          } else {
            // Fallback for unexpected states
            return const Center(
              child: Text(
                "No tasks available.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: _auth.currentUser == null
      ? null
      : FloatingActionButton(
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
  TaskAssignment _addTask(TaskAssignment newTask){
    addTaskToDB(newTask);
    return newTask;
  }

  Future<void> addTaskToDB(TaskAssignment newTask) async {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;

    if (_fireAuth.currentUser != null) {
      final url = Uri.parse('https://planner-appimage-823612132472.us-central1.run.app/tasks');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(newTask.toJson()),
        );
        setState(() {});

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Task5: ${response.body}');
        } else {
          throw Exception('Task5: Failed to fetch tasks. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Task5: Error fetching tasks: $e');
      }
    }
  }

  // Update existing task
  TaskAssignment _updateTask(TaskAssignment updatedTask) {
    setState(() {
      final index = tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
    });
    return updatedTask;
  }

  Future<TaskAssignment?> _updateTaskInformation(TaskAssignment task) async{
    final TaskAssignment? updatedTask = await showDialog<TaskAssignment>(
      context: context,
      builder: (context) {
        return TaskForm(
          task: task,
          onSave: (updatedTask) {return updatedTask;},
        );
      },
    );

    if (updatedTask == null) {
      return null;
    }
    else {
      await updateTaskInDB(updatedTask);
      setState(() {});
      return updatedTask;
    }
  }

  Future<void> updateTaskInDB(TaskAssignment updatedTask) async {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;

    if (_fireAuth.currentUser != null) {
      final url = Uri.parse('https://planner-appimage-823612132472.us-central1.run.app/tasks');

      try {
        Map<String, dynamic> taskJson = updatedTask.toJson();
        taskJson['assignment_id'] = updatedTask.id;
        final response = await http.patch(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(taskJson),
        );
        setState(() {});

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Task5: ${response.body}');
        } else {
          throw Exception('Task5: Failed to fetch tasks. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Task5: Error fetching tasks: $e');
      }
    }
  }

  void _deleteTask(TaskAssignment taskToDelete) async {
    await deleteTaskFromDB(taskToDelete);
    setState(() {});
  }

  Future<void> deleteTaskFromDB(TaskAssignment taskToDelete) async {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;

    if (_fireAuth.currentUser != null) {
      final url = Uri.parse('https://planner-appimage-823612132472.us-central1.run.app/tasks');

      try {
        final response = await http.delete(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'assignment_id': taskToDelete.id,
          }),
        );

        print('Task5: task id was: ${taskToDelete.id}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Task5: ${response.body}');
        } else {
          throw Exception('Task5: Failed to fetch tasks. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Task5: Error fetching tasks: $e');
      }
    }
  }

  void _toggleTaskCompletion(TaskAssignment task, bool? value) async{
    task.completed = value ?? false;
    task.completeDate = value ?? false ? DateTime.now() : null;
    await updateTaskInDB(task);
    setState(() {
      _setSubtasksCompletion(task.id, value ?? false);
    });
  }

  void _setSubtasksCompletion(String parentId, bool completed) {
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
          completeDate: completed ? DateTime.now() : null,
          parentId: tasks[index].parentId,
        );
        updateTaskInDB(tasks[index]);
      }

      // Recursively update this child's subtasks
      _setSubtasksCompletion(child.id, completed);
    }
  }


  // Add a subtask to a parent task
  Future<TaskAssignment?> _addSubtask(TaskAssignment parentTask) async{
    // Show a TaskForm and set the parentId of the new task to parentTask.id
    final TaskAssignment? newSubtask = await showDialog<TaskAssignment>(
      context: context,
      builder: (context) {
        return TaskForm(
          onSave: (newSubtask) {
            newSubtask.parentId = parentTask.id;
            tasks.add(newSubtask);
            return newSubtask;
          },
        );
      },
    );

    if (newSubtask == null) {
      return null;
    }
    else {
      await addTaskToDB(newSubtask);
      setState(() {});
      return newSubtask;
    }
  }

  // Edit an existing subtask
  Future<TaskAssignment?> _editSubtask(TaskAssignment subtask) async {
    final TaskAssignment? updatedSubtask = await showDialog<TaskAssignment>(
      context: context,
      builder: (context) {
        return TaskForm(
          task: subtask,
          onSave: (updatedTask) {return updatedTask;},
        );
      },
    );

    if (updatedSubtask == null){
      return null;
    }
    else {
      await updateTaskInDB(subtask);
      setState((){});
      return updatedSubtask;
    }
  }

  // Delete a subtask
  void _deleteSubtask(TaskAssignment subtaskToDelete) async{
    await deleteTaskFromDB(subtaskToDelete);
    setState(() {});
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