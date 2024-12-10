import 'package:flutter/material.dart';
import 'package:planner_app/classes/task_assignment.dart';
import 'package:planner_app/pages/single_assignment.dart';
import '../classes/project_assignment.dart';
import 'package:date_time_format/date_time_format.dart';

class ProjectWidget extends StatelessWidget {
  final ProjectAssignment project;
  final List<TaskAssignment> allTasks;
  final Function(ProjectAssignment) onAddTask;
  final Function(ProjectAssignment) onProjectUpdate;
  final Function(ProjectAssignment) onDelete;
  final Function(ProjectAssignment, bool?) onToggleProjectCompletion;

  final Function(TaskAssignment, bool?) onToggleTaskCompletion;
  final Function(TaskAssignment) onEditTask;
  final Function(TaskAssignment) onDeleteTask;

  ProjectWidget({
    required this.project,
    required this.allTasks,
    required this.onAddTask,
    required this.onProjectUpdate,
    required this.onDelete,
    required this.onToggleTaskCompletion,
    required this.onEditTask,
    required this.onDeleteTask,
    required this.onToggleProjectCompletion,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectTasks = allTasks.where((t) => t.parentId == project.id).toList();

    String formattedDueDate = project.dueDate == null ?
      'No Due Date' :
      project.dueDate!.format(DateTimeFormats.american);

    void _navigateToDetails(){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(
              assignment: project,
              subTasks: projectTasks,
              onProjectUpdate: onProjectUpdate,
              onToggleProjectCompletion: onToggleProjectCompletion,
              onToggleTaskCompletion: onToggleTaskCompletion,
              onEditSubtask: onEditTask,
              onAddTask: onAddTask,
              onDeleteSubtask: onDeleteTask,
            )
          )
      );
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: _navigateToDetails,
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
                value: project.completed,
                onChanged: (value) {
                  onToggleProjectCompletion(project, value);
                },
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
                    : const TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Colors.black54
                      ) ,
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.black,
                  disabledColor: Colors.blueGrey,
                  onPressed: () {
                    onProjectUpdate(project);
                    },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.black,
                  disabledColor: Colors.blueGrey,
                  onPressed: () {
                    onDelete(project);
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
              title: Text('${formattedDueDate} | id: ${project.id}'),
              children: [
                // Display tasks for this project using TaskWidget
                for (final task in projectTasks)
                  _buildSubtaskRow(context, task),

                // Add a plus icon for adding a new top-level task to this project
                ListTile(
                  leading: Icon(Icons.add, color: Theme.of(context).primaryColor),
                  title: Text('Add a new task', style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () => onAddTask(project),
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
        fillColor: const WidgetStatePropertyAll(Colors.white),
        side: BorderSide(color: subtask.completed ? Colors.black : Colors.blue),
        checkColor: Colors.black,
        value: subtask.completed,
        onChanged: (value) => onToggleTaskCompletion(subtask, value),
      ),
      title: Text(
        subtask.subject,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '$subtaskDueText\nid: ${subtask.id}',
        style: const TextStyle(color: Colors.black, fontSize: 15),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onEditTask(subtask),
            color: Colors.black,
            disabledColor: Colors.blueGrey,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDeleteTask(subtask),
            color: Colors.black,
            disabledColor: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}
