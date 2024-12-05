import 'package:flutter/material.dart';
import '../classes/project_assignment.dart';
import 'package:date_time_format/date_time_format.dart';

class ProjectWidget extends StatelessWidget {
  final ProjectAssignment project;

  ProjectWidget({required this.project, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDueDate = project.dueDate.format(DateTimeFormats.american);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              tileColor: Colors.white,
              leading: Icon(
                project.completed
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: project.completed ? Colors.black : Colors.blue,
              ),
              title: Text(
                project.subject,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                project.notes ?? 'No Description',
                style: project.notes == null
                    ? const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.red,
                      )
                    : null,
              ),
              trailing: const Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.black,
                  disabledColor: Colors.red,
                  onPressed: null,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.black,
                  disabledColor: Colors.red,
                  onPressed: null,
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      const Icon(
                          Icons.brightness_1,
                          size: 8,
                          color: Colors.white
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(formattedDueDate)),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(
                          Icons.brightness_1,
                          size: 8,
                          color: Colors.white
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(project.members.toString())),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
