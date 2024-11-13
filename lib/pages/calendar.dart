import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For Google Fonts
import 'package:planner_app/pages/login.dart';
import 'package:planner_app/pages/home.dart';
import 'package:planner_app/pages/monthcalendar.dart'; // Import Monthcalendar page
import 'package:planner_app/pages/task.dart';
import 'package:planner_app/pages/project.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  int _currentIndex = 0;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _topAppBar(),

      body: Stack(
        children: [
          // Align the button to the top-right corner, with minimized space from the app bar
          Positioned(
            top: 10, // Adjusted to minimize space between the app bar and button
            right: 10, // Align to the very right edge of the screen
            child: ElevatedButton(
              onPressed: _monthTaskPageRoute,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Customize button padding
              ),  // Navigate to Monthcalendar page
              child: const Text(
                "Month's Tasks:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Center the text below the button
          Positioned(
            top: 70, // Position the text below the button
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Task Due This Month',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    const Shadow(
                      blurRadius: 6.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Add Row with gray background and blue checkbox
          Positioned(
            top: 120, // Adjust position below the title text
            left: 20,
            right: 20,
            child: Container(
              color: const Color.fromARGB(226, 224, 224, 224), // Gray background for the row
              child: Row(
                children: [
                  // Blue checkbox on the left
                  Container(
                    margin: const EdgeInsets.all(4.0), // Reduced margin around the checkbox
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(226, 224, 224, 224), // Keeping the background gray
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Transform.scale(
                      scale: 1.5, // Increase the size of the checkbox (adjust scale as needed)
                      child: Checkbox(
                        value: _isChecked,
                        activeColor: const Color.fromARGB(255, 117, 185, 241), // Checkbox fills with blue when checked
                        checkColor: Colors.white, // The checkmark will be white
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                    ),
                  ),

                  // Task Subject - Use Expanded to fill the space before the due date
                  Expanded(
                    child: const Text(
                      'Task Subject',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Due day after Task Subject - Positioned close to the task subject
                  const Text(
                    'Due Data', // Example due date, replace it dynamically as needed
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),

                  // Icons at the end (Pen and Garbage Can) - Minimized space between the icons
                  Row(
                    mainAxisSize: MainAxisSize.min, // Make sure the icons are closely packed
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle pen (edit) icon action
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle garbage can (delete) icon action
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: _bottomNavBar(),
    );
  }

  PreferredSizeWidget _topAppBar() {
    return AppBar(
      leading: TextButton.icon(
        onPressed: _homePageRoute,
        label: const Icon(Icons.home),
      ),
      backgroundColor: const Color.fromARGB(255, 3, 64, 113),
      title: const Text('Planner App Calendar'),
      actions: <Widget>[
        TextButton(onPressed: _loginPageRoute, child: const Text('LOGIN')),
      ],
    );
  }

  Widget _bottomNavBar() {
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

  void _onTap(int index) {
    switch(index) {
      case 0:
        break;  // Stay on the Calendar page
      case 1:
        _taskPageRoute();
        break;
      case 2:
        _projectPageRoute();
        break;
    }
  }

  void _loginPageRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _homePageRoute() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage())
    );
  }

  void _taskPageRoute() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TaskPage())
    );
  }

  void _projectPageRoute() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProjectPage())
    );
  }

  // Navigate to the Monthcalendar page
  void _monthTaskPageRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Monthcalendar()),
    );
  }
}
