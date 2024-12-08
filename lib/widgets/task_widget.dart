import 'package:flutter/material.dart';
import 'package:planner_app/classes/task_assignment.dart';
import 'package:date_time_format/date_time_format.dart';

class TaskWidget extends StatelessWidget {
  final TaskAssignment task;
  final List<TaskAssignment> allTasks;
  final Function(TaskAssignment) onTaskUpdate;
  final Function(TaskAssignment) onDelete;
  final void Function(TaskAssignment parentTask) onAddSubtask;
  final void Function(TaskAssignment subtask, bool? value) onToggleSubtask;
  final void Function(TaskAssignment subtask) onEditSubtask;
  final void Function(TaskAssignment subtask) onDeleteSubtask;
  final Function(TaskAssignment, bool?) onToggleTaskCompletion;

  const TaskWidget({
    Key? key,
    required this.task,
    required this.allTasks,
    required this.onTaskUpdate,
    required this.onDelete,
    required this.onAddSubtask,
    required this.onToggleSubtask,
    required this.onEditSubtask,
    required this.onDeleteSubtask,
    required this.onToggleTaskCompletion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subtasks = allTasks.where((t) => t.parentId == task.id).toList();

    String formattedDueDate = task.dueDate == null ?
    'No Due Date' :
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
              leading: Checkbox(
                fillColor: WidgetStatePropertyAll(Colors.white),
                side: WidgetStateBorderSide.resolveWith((states) {
                  if (states.contains(WidgetState.selected))
                    return const BorderSide(color: Colors.black);
                  else
                    return const BorderSide(color: Colors.blue);
                }
                ),
                checkColor: Colors.black,
                value: task.completed,
                onChanged: (value) {
                  onToggleTaskCompletion(task, value);
                },
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
            ExpansionTile(
              backgroundColor: Colors.white70,
              textColor: Colors.black,
              iconColor: Colors.black,
              collapsedBackgroundColor: Colors.black,
              collapsedTextColor: Colors.white,
              collapsedIconColor: Colors.white,
              title: Text(
                  (formattedDueDate + ' | id: ' + task.id.toString()),
              ),
              children: [
                for (final subtask in subtasks) _buildSubtaskRow(context, subtask),

                // Add a plus icon for adding a new subtask
                ListTile(
                  leading: Icon(Icons.add, color: Theme.of(context).primaryColor),
                  title: Text('Add a new subtask', style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () => onAddSubtask(task), // Pass the parent task
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtaskRow(BuildContext context, TaskAssignment subtask) {
    String subtaskDueText = subtask.dueDate != null
        ? subtask.dueDate!.format(DateTimeFormats.american)
        : "No due date";

    return ListTile(
      leading: Checkbox(
        fillColor: WidgetStatePropertyAll(Colors.white),
        side: WidgetStateBorderSide.resolveWith((states) {
            if (states.contains(WidgetState.selected))
              return const BorderSide(color: Colors.black);
            else
              return const BorderSide(color: Colors.blue);
          }
        ),
        checkColor: Colors.black,
        value: subtask.completed,
        onChanged: (value) => onToggleSubtask(subtask, value),
      ),
      title: Text(
          subtask.subject,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
      ),
      subtitle: Text(
          (subtaskDueText + '\nid: ' + subtask.id.toString()),
        style: TextStyle(color: Colors.black, fontSize: 15)
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => onEditSubtask(subtask),
            color: Colors.black,
            disabledColor: Colors.blueGrey,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDeleteSubtask(subtask),
            color: Colors.black,
            disabledColor: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}
