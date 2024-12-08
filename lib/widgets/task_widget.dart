import 'package:flutter/material.dart';
import 'package:planner_app/classes/task_assignment.dart';
import 'package:date_time_format/date_time_format.dart';

class TaskWidget extends StatelessWidget {
  final TaskAssignment task;
  final Function(TaskAssignment) onTaskUpdate;
  final Function(TaskAssignment) onDelete;

  const TaskWidget({
    Key? key,
    required this.task,
    required this.onTaskUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDueDate = task.dueDate == null ?
    '' :
    task.dueDate!.format(DateTimeFormats.american);

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
                task.completed
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: task.completed ? Colors.black : Colors.blue,
              ),
              title: Text(
                task.subject,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                task.notes ?? 'No Description',
                style: task.notes == null
                    ? const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.red,
                )
                    : const TextStyle(
                    fontStyle: FontStyle.normal,
                    color: Colors.black54
                ) ,
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.black,
                  disabledColor: Colors.blueGrey,
                  onPressed: () {
                    onTaskUpdate(task);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.black,
                  disabledColor: Colors.blueGrey,
                  onPressed: () {
                    onDelete(task);
                  },
                )
              ]),
            ),
            Container(
              color: Colors.white54,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formattedDueDate,
                        style: TextStyle(color: Colors.black)
                      )
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
