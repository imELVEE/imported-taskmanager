import 'package:flutter/material.dart';
import 'package:planner_app/pages/calendar.dart';

class Monthcalendar extends StatefulWidget {
  const Monthcalendar({super.key});

  @override
  State<Monthcalendar> createState() => _MonthcalendarState();
}

class _MonthcalendarState extends State<Monthcalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Month Calendar'),
        backgroundColor: const Color.fromARGB(255, 3, 64, 113),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to the CalendarPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarPage()),
            );
          },
          style: ElevatedButton.styleFrom(
          ),
          child: const Text('Go to Calendar'),
        ),
      ),
    );
  }
}
