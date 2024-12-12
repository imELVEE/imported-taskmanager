import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planner_app/classes/project_assignment.dart';
import 'package:planner_app/classes/task_assignment.dart';
import 'package:planner_app/pages/login.dart';
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/logout.dart';
import 'package:planner_app/pages/support.dart';
import 'package:planner_app/pages/task.dart';
import 'package:planner_app/widgets/project_form.dart';
import 'package:planner_app/widgets/task_form.dart';
import 'package:planner_app/widgets/projects_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProjectPage extends StatefulWidget{
  const ProjectPage({super.key});

  @override
  ProjectPageState createState() => ProjectPageState();
}

class ProjectPageState extends State<ProjectPage> {
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ProjectAssignment> projects = [];
  List<TaskAssignment> allTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchAndSetData(); // Initialize future in `initState`
  }

  Future<Map<String, dynamic>> _fetchData() async {
    try {
      final results  = await Future.wait([
        fetchProjects(),
        fetchTasks(),
      ]);

      return {
        'projects': results[0] as List<ProjectAssignment>,
        'tasks': results[1] as List<TaskAssignment>,
      };
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  // Combined fetch for projects and tasks
  Future<void> _fetchAndSetData() async {
    try {
      final fetchedData = await _fetchData();

      setState(() {
        projects = fetchedData[0] as List<ProjectAssignment>;
        allTasks = fetchedData[1] as List<TaskAssignment>;
      });

    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<ProjectAssignment>> fetchProjects() async {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;

    if (_fireAuth.currentUser != null) {
      final url = Uri.parse('https://planner-appimage-823612132472.us-central1.run.app/assignments');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _fireAuth.currentUser?.email,
            'assignment_type': 'Projects',
          }),
        );

        if (response.statusCode == 200) {
          return parseProjectsFromJson(response.body);
        } else {
          throw Exception('Failed to fetch projects. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Error fetching projects: $e');
      }
    } else {
      return [];
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

        if (response.statusCode == 200) {
          //print('TASKS RSP1: ${response.body}');
          return parseTasksFromJson(response.body);
        } else {
          throw Exception('Failed to fetch tasks. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Error fetching tasks: $e');
      }
    } else {
      return [];
    }
  }

  List<ProjectAssignment> parseProjectsFromJson(String jsonString) {
    final dynamic outerDecoded = jsonDecode(jsonString);
    final List<dynamic> jsonData = outerDecoded is String
        ? jsonDecode(outerDecoded)
        : outerDecoded;

    return jsonData.map((item) {
      final map = item as Map<String, dynamic>;
      return ProjectAssignment(
        id: map['assignment_id'] ?? '',
        createDate: DateTime.tryParse(map['create_date'] ?? '') ?? DateTime.now(),
        dueDate: map['due_date'] != null ? DateTime.tryParse(map['due_date']) : null,
        subject: map['subject'] ?? 'No Subject',
        notes: map['notes'] ?? '',
        completed: map['projects'] != null ? map['projects']['completed'] : false,
        completeDate: map['projects'] != null ? map['projects']['completed_date'] : null,
      );
    }).toList();
  }

  List<TaskAssignment> parseTasksFromJson(String jsonString) {
    final dynamic outerDecoded = jsonDecode(jsonString);
    final List<dynamic> jsonData = outerDecoded is String
        ? jsonDecode(outerDecoded)
        : outerDecoded;

    return jsonData.map((item) {
      final map = item as Map<String, dynamic>;
      return TaskAssignment(
        id: map['assignment_id'] ?? '',
        createDate: DateTime.tryParse(map['create_date'] ?? '') ?? DateTime.now(),
        dueDate: map['due_date'] != null ? DateTime.tryParse(map['due_date']) : null,
        subject: map['subject'] ?? 'No Subject',
        notes: map['notes'] ?? '',
        completed: map['tasks'] != null ? map['tasks']['completed'] : false,
        completeDate: map['tasks'] != null ? map['tasks']['completed_date'] : null,
        parentId: map['tasks'] != null ? map['tasks']['parent_project'] : null,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: _topAppBar(),

      body: _auth.currentUser == null
      ? const Center(
        child: Text(
          "Please log in to view projects.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      )
      : FutureBuilder<Map<String, dynamic>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.blue));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            final projects = snapshot.data!['projects'] as List<ProjectAssignment>;
            final allTasks = snapshot.data!['tasks'] as List<TaskAssignment>;

            if (projects.isEmpty) {
              return const Center(
                child: Text(
                  "No projects available.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            return ProjectsList(
              projects: projects,
              allTasks: allTasks,
              onProjectUpdate: _updateProjectInformation,
              onDelete: _deleteProject,
              onAddTask: _addTaskToProject,
              onToggleTaskCompletion: _toggleTaskCompletion,
              onEditTask: _editTask,
              onDeleteTask: _deleteTask,
              onToggleProjectCompletion: _toggleProjectCompletion,
            );
          } else {
            return const Center(
              child: Text(
                "No projects available.",
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
              return ProjectForm(
                onSave: _addProject,
              );
            },
          );
        }, // Open form to add new task
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: _bottomNavBar(),
    );
  }

  // Add new project to the list
  void _addProject(ProjectAssignment newProject) async {
    await addProjectToDB(newProject);
  }

  Future<void> addProjectToDB(ProjectAssignment newProject) async {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;

    if (_fireAuth.currentUser != null) {
      final url = Uri.parse('https://planner-appimage-823612132472.us-central1.run.app/projects');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(newProject.toJson()),
        );
        setState(() {});

        if (response.statusCode == 200 || response.statusCode == 201) {
          //print('Project5: ${response.body}');
        } else {
          throw Exception('Project5: Failed to fetch projects. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Project5: Error fetching projects: $e');
      }
    }
  }

  // Update existing project
  ProjectAssignment _updateProject(ProjectAssignment updatedProject) {
    return updatedProject;
  }

  Future<ProjectAssignment?> _updateProjectInformation(ProjectAssignment project) async {
    final ProjectAssignment? updatedProject = await showDialog<ProjectAssignment>(
      context: context,
      builder: (context) {
        return ProjectForm(
          project: project,
          onSave: _updateProject,
        );
      },
    );

    if (updatedProject == null){
      return null;
    }
    else {
      await updateProjectInDB(updatedProject);
      return updatedProject;
    }
  }

  Future<void> updateProjectInDB(ProjectAssignment updatedProject) async {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;

    if (_fireAuth.currentUser != null) {
      final url = Uri.parse('https://planner-appimage-823612132472.us-central1.run.app/projects');

      try {
        Map<String, dynamic> projectJson = updatedProject.toJson();
        projectJson['assignment_id'] = updatedProject.id;
        final response = await http.patch(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(projectJson),
        );
        setState(() {});

        if (response.statusCode == 200 || response.statusCode == 201) {
          //print('Project5: ${response.body}');
        } else {
          throw Exception('Project5: Failed to fetch projects. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Project5: Error fetching projects: $e');
      }
    }
  }

  void _deleteProject(ProjectAssignment projectToDelete) async{
    await deleteProjectFromDB(projectToDelete);
    setState(() {});
  }

  Future<void> deleteProjectFromDB(ProjectAssignment projectToDelete) async {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;

    if (_fireAuth.currentUser != null) {
      final url = Uri.parse('https://planner-appimage-823612132472.us-central1.run.app/projects');

      try {
        final response = await http.delete(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'assignment_id': projectToDelete.id,
          }),
        );

        //print('Project5: project id was: ${projectToDelete.id}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          //print('Project5: ${response.body}');
        } else {
          throw Exception('Project5: Failed to fetch projects. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Project5: Error fetching projects: $e');
      }
    }
  }

  void _removeAllTasksUnderProject(String projectId) {
    final projectTasks = allTasks.where((task) => task.parentId == projectId).toList();

    for (final task in projectTasks) {
      allTasks.removeWhere((t) => t.id == task.id);
      _removeAllDescendants(task.id); // Recursively remove subtasks
    }
  }

  void _toggleProjectCompletion(ProjectAssignment project, bool? value) async{
    project.completed = value ?? false;
    project.completeDate = value ?? false ? DateTime.now() : null;
    await updateProjectInDB(project);
    setState(() {
        _setProjectTasksCompletion(project.id, value ?? false);
    });
  }

  void _setProjectTasksCompletion(String projectId, bool completed) async {
    // Find all tasks directly under this project
    final projectTasks = allTasks.where((t) => t.parentId == projectId).toList();
    for (var task in projectTasks) {
      final index = allTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        allTasks[index] = allTasks[index].copyWith(
            completed: completed,
            completeDate: completed ? DateTime.now() : null
        );
        await updateTaskInDB(allTasks[index]);
        _setSubtasksCompletion(allTasks[index].id, completed);
      }
    }
  }

  Future<void> updateTaskInDB(TaskAssignment updatedTask) async {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;

    if (_fireAuth.currentUser != null) {
      final url = Uri.parse('https://planner-appimage-823612132472.us-central1.run.app/tasks');

      try {
        Map<String, dynamic> taskJson = updatedTask.toProjectJson();
        taskJson['assignment_id'] = updatedTask.id;
        final response = await http.patch(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(taskJson),
        );
        setState(() {});

        if (response.statusCode == 200 || response.statusCode == 201) {
          //print('Task5: ${response.body}');
        } else {
          throw Exception('Task5: Failed to fetch tasks. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Task5: Error fetching tasks: $e');
      }
    }
  }

  Future<TaskAssignment?> _addTaskToProject(ProjectAssignment project) async{
    final TaskAssignment? newSubtask = await showDialog<TaskAssignment>(
      context: context,
      builder: (context) {
        return TaskForm(
          onSave: (newTask) {
            setState(() {
              newTask.parentId = project.id;
              allTasks.add(newTask);
            });
            return newTask;
          },
        );
      },
    );

    if (newSubtask == null) {
      return null;
    }
    else {
      await addTaskToDB(newSubtask);
      return newSubtask;
    }
  }

  Future<void> addTaskToDB(TaskAssignment newTask) async {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;

    if (_fireAuth.currentUser != null) {
      final url = Uri.parse('https://planner-appimage-823612132472.us-central1.run.app/tasks');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(newTask.toProjectJson()),
        );
        setState(() {});

        if (response.statusCode == 200 || response.statusCode == 201) {
          //print('Task5: ${response.body}');
        } else {
          throw Exception('Task5: Failed to fetch tasks. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Task5: Error fetching tasks: $e');
      }
    }
  }

  // Toggle top-level task completion (and optionally its subtasks)
  void _toggleTaskCompletion(TaskAssignment task, bool? value) async {
    task.completed = value ?? false;
    task.completeDate = value ?? false ? DateTime.now() : null;
    await updateTaskInDB(task);
    setState(() {
      final index = allTasks.indexWhere((t) => t.id == task.id);
      _setSubtasksCompletion(allTasks[index].id, value ?? false);
    });
  }

  void _setSubtasksCompletion(String parentId, bool completed) async{
    final childTasks = allTasks.where((t) => t.parentId == parentId).toList();
    for (var child in childTasks) {
      final index = allTasks.indexWhere((t) => t.id == child.id);
      if (index != -1) {
        allTasks[index] = allTasks[index].copyWith(
            completed: completed,
            completeDate: completed ? DateTime.now() : null
        );
        await updateTaskInDB(allTasks[index]);
        _setSubtasksCompletion(allTasks[index].id, completed);
      }
    }
  }

  // Edit a top-level task or subtask
  Future<TaskAssignment?> _editTask(TaskAssignment task) async{
    final TaskAssignment? updatedSubtask = await showDialog<TaskAssignment>(
      context: context,
      builder: (context) {
        return TaskForm(
          task: task,
          onSave: (updatedTask) {
            final index = allTasks.indexWhere((t) => t.id == updatedTask.id);
            if (index != -1) {
              allTasks[index] = updatedTask;
            }
            return updatedTask;
          },
        );
      },
    );

    if (updatedSubtask == null){
      return null;
    }
    else {
      await updateTaskInDB(task);
      return updatedSubtask;
    }
  }

  // Delete a top-level task
  void _deleteTask(TaskAssignment taskToDelete) async {
    await deleteTaskFromDB(taskToDelete);
    //_removeAllDescendants(taskToDelete.id);
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

        //print('Task5: task id was: ${taskToDelete.id}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          //print('Task5: ${response.body}');
        } else {
          throw Exception('Task5: Failed to fetch tasks. Status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Task5: Error fetching tasks: $e');
      }
    }
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
        if (_auth.currentUser != null) ...[
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
  void _logOutPageRoute() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogOutPage()),
    );
  }
}