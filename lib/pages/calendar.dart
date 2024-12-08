// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:planner_app/pages/login.dart';
// import 'package:planner_app/pages/home.dart';
// import 'package:planner_app/pages/monthcalendar.dart';
// import 'package:planner_app/pages/task.dart';
// import 'package:planner_app/pages/project.dart';

// class CalendarPage extends StatefulWidget {
//   const CalendarPage({super.key});

//   @override
//   CalendarPageState createState() => CalendarPageState();
// }

// class CalendarPageState extends State<CalendarPage> {
//   final int _currentIndex = 0;
//   List<Map<String, String>> tasks = [
//     {'subject': 'New Task', 'dueDate': 'Due Date'},
//   ];
//   final List<bool> _checkedStates = [false];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _topAppBar(),
//       body: Stack(
//         children: [
//           Positioned(
//             top: 10,
//             right: 10,
//             child: ElevatedButton(
//               onPressed: _monthTaskPageRoute,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               ),
//               child: const Text(
//                 "Month's Tasks",
//                 style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 70,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Text(
//                 'Task Due This Month:',
//                 style: GoogleFonts.poppins(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 120,
//             left: 20,
//             right: 20,
//             bottom: 80,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: tasks.asMap().map((index, task) {
//                   return MapEntry(index, Container(
//                     margin: const EdgeInsets.only(bottom: 10.0),
//                     color: const Color.fromARGB(226, 224, 224, 224),
//                     child: Row(
//                       children: [
//                         _buildCheckbox(index),
//                         _buildTaskSubject(index, task),
//                         _buildDueDate(index, task),
//                         _buildIcons(index),
//                       ],
//                     ),
//                   ));
//                 }).values.toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addTask,
//         backgroundColor: const Color(0xFF90C4FF),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//       bottomNavigationBar: _bottomNavBar(),
//     );
//   }

//   PreferredSizeWidget _topAppBar() {
//     return AppBar(
//       leading: TextButton.icon(
//         onPressed: _homePageRoute,
//         label: const Icon(Icons.home),
//       ),
//       backgroundColor: const Color.fromARGB(255, 3, 64, 113),
//       title: const Text('Planner App Calendar'),
//       actions: [
//         TextButton(onPressed: _loginPageRoute, child: const Text('LOGIN')),
//       ],
//     );
//   }

//   Widget _bottomNavBar() {
//     return BottomNavigationBar(
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendar'),
//         BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
//         BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Projects'),
//       ],
//       onTap: _onTap,
//       currentIndex: _currentIndex,
//     );
//   }

//   void _onTap(int index) {
//     switch (index) {
//       case 0:
//         break;
//       case 1:
//         _taskPageRoute();
//         break;
//       case 2:
//         _projectPageRoute();
//         break;
//     }
//   }

//   void _loginPageRoute() {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
//   }

//   void _homePageRoute() {
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
//   }

//   void _taskPageRoute() {
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TaskPage()));
//   }

//   void _projectPageRoute() {
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProjectPage()));
//   }

//   void _monthTaskPageRoute() {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => const Monthcalendar()));
//   }

//   Future<void> _pickDueDate(int index) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData(
//             colorScheme: const ColorScheme.light(primary: Color(0xFF90C4FF), onPrimary: Colors.white, onSurface: Colors.black),
//             scaffoldBackgroundColor: const Color(0xFF90C4FF),
//             buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (selectedDate != null && selectedDate != DateTime.now()) {
//       setState(() {
//         tasks[index]['dueDate'] = '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
//       });
//     }
//   }

//   void _addTask() {
//     setState(() {
//       tasks.add({'subject': 'New Task', 'dueDate': 'Due Date'});
//       _checkedStates.add(false);
//     });
//   }

//   Future<void> _editTaskSubject(int index) async {
//     TextEditingController controller = TextEditingController(text: tasks[index]['subject']);
//     String? newSubject = await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Edit Task Subject', style: TextStyle(color: Colors.black)),
//           backgroundColor: Colors.white,
//           content: TextField(
//             controller: controller,
//             decoration: const InputDecoration(hintText: "Enter new task subject"),
//             style: const TextStyle(color: Colors.black),
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.black))),
//             TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Save', style: TextStyle(color: Colors.black))),
//           ],
//         );
//       },
//     );

//     if (newSubject != null && newSubject.isNotEmpty) {
//       setState(() {
//         tasks[index]['subject'] = newSubject;
//       });
//     }
//   }

//   void _deleteTask(int index) {
//     setState(() {
//       tasks.removeAt(index);
//       _checkedStates.removeAt(index);
//     });
//   }

//   Widget _buildCheckbox(int index) {
//     return Container(
//       margin: const EdgeInsets.all(4.0),
//       child: Transform.scale(
//         scale: 1.5,
//         child: Checkbox(
//           value: _checkedStates[index],
//           activeColor: const Color(0xFF90C4FF),
//           checkColor: Colors.white,
//           onChanged: (bool? value) {
//             setState(() {
//               _checkedStates[index] = value ?? false;

//               if (_checkedStates[index]) {
//                 var task = tasks.removeAt(index);
//                 tasks.add(task);
//                 var checkedState = _checkedStates.removeAt(index);
//                 _checkedStates.add(checkedState);
//               }
//             });
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildTaskSubject(int index, Map<String, String> task) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => _editTaskSubject(index),
//         child: Text(
//           task['subject']!,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//       ),
//     );
//   }

//   Widget _buildDueDate(int index, Map<String, String> task) {
//     return GestureDetector(
//       onTap: () => _pickDueDate(index),
//       child: Text(
//         task['dueDate']!,
//         style: const TextStyle(fontSize: 16, color: Colors.black),
//       ),
//     );
//   }

//   Widget _buildIcons(int index) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(onPressed: () => _editTaskSubject(index), icon: const Icon(Icons.edit, color: Colors.black)),
//         IconButton(onPressed: () => _deleteTask(index), icon: const Icon(Icons.delete, color: Colors.black)),
//       ],
//     );
//   }
// }
