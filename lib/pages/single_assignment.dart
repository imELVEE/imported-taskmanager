import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:planner_app/classes/project_assignment.dart';
import 'package:planner_app/classes/task_assignment.dart';
import 'package:planner_app/widgets/project_form.dart';
import 'package:planner_app/widgets/task_form.dart';


class DetailPage extends StatefulWidget {
  final dynamic assignment;
  // assignment can be ProjectAssignment or TaskAssignment
  final List<TaskAssignment> subTasks;

  final Function(ProjectAssignment)? onProjectUpdate;
  final Function(TaskAssignment)? onTaskUpdate;

  final Function(ProjectAssignment, bool?)? onToggleProjectCompletion;
  final Function(TaskAssignment, bool?) onToggleTaskCompletion;
  final Function(TaskAssignment) onEditSubtask;
  final Function(TaskAssignment) onDeleteSubtask;

  const DetailPage({
    Key? key,
    required this.assignment,
    required this.subTasks,
    this.onProjectUpdate,
    this.onTaskUpdate,
    this.onToggleProjectCompletion,
    required this.onToggleTaskCompletion,
    required this.onEditSubtask,
    required this.onDeleteSubtask,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  bool isProject() {
    return widget.assignment is ProjectAssignment;
  }

  bool isTask() {
    return widget.assignment is TaskAssignment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.assignment.subject),
      ),
      body: _buildSubList(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          _editAssignment(context);
        },
      ),
    );
  }

  Widget _buildSubList(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          Text(
            'Subtasks',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final subtask in widget.subTasks) _buildSubtaskRow(context, subtask),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final thisAssignment;
    if (isProject()) {
      thisAssignment = widget.assignment as ProjectAssignment;
    } else {
      thisAssignment = widget.assignment as TaskAssignment;
    }

    String formattedDueDate = thisAssignment.dueDate == null
        ? 'No Due Date'
        : DateTimeFormat.format(thisAssignment.dueDate!, format: DateTimeFormats.american);

    String formattedCreateDate = DateTimeFormat.format(thisAssignment.createDate!, format: DateTimeFormats.american);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              fillColor: const WidgetStatePropertyAll(Colors.white),
              side: WidgetStateBorderSide.resolveWith((states) {
                if (states.contains(WidgetState.selected))
                  return const BorderSide(color: Colors.black);
                else
                  return const BorderSide(color: Colors.blue);
              }
              ),
              checkColor: Colors.black,
              value: thisAssignment.completed,
              onChanged: (value) {
                // Change state in parent widget
                if (isProject()) {
                  widget.onToggleProjectCompletion!(thisAssignment, value);
                }
                else {
                  widget.onToggleTaskCompletion(thisAssignment, value);
                }

                // change checkbox regardles of thisAssignment type
                setState(() {
                  thisAssignment.completed = value ?? false;
                  for (final sub in widget.subTasks) {
                    sub.completed = value ?? false;
                  }
                });
              },
            ),
            Expanded(
              child: Text(
                thisAssignment.subject,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: thisAssignment.completed ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.red,
                  decorationThickness: 2.0,
                ),
              ),
            ),
          ],
        ),
        Text(
          'Description: ' + thisAssignment.notes ?? 'No description',
          style: thisAssignment.notes == null
            ? const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.red,
            )
            : const TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
        ),
        const SizedBox(height: 8),
        Text('Due: ${formattedDueDate} | id: ${thisAssignment.id}',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.normal
          )
        ),
        const SizedBox(height: 8),
        Text('Created On: ${formattedCreateDate}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal
            )
        ),
      ],
    );
  }

  Widget _buildSubtaskRow(BuildContext context, TaskAssignment subtask) {
    String subtaskDueText = subtask.dueDate != null
        ? DateTimeFormat.format(subtask.dueDate!, format: DateTimeFormats.american)
        : "No due date";

    Future<void> _editSubtaskLocal() async {
      subtask = await widget.onEditSubtask(subtask);
      print('Subject 2: ${subtask.subject}');
      setState(() {
        final index = widget.subTasks.indexWhere((t) => t.id == subtask.id);
        if (index != -1) {
          widget.subTasks[index] = subtask;
        }
      });
    }

    return ListTile(
      leading: Checkbox(
        value: subtask.completed,
        onChanged: (value) {
          widget.onToggleTaskCompletion(subtask, value);
          setState(() {
            subtask.completed = value ?? false;
          });
        },
      ),
      title: Text(
        subtask.subject,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          decoration: subtask.completed ? TextDecoration.lineThrough : null,
          decorationColor: Colors.red,
          decorationThickness: 2.0,
        ),
      ),
      subtitle: Text(
        'DUE: ${subtaskDueText}',
        style: const TextStyle(color: Colors.redAccent, fontSize: 15),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _editSubtaskLocal();
            },
            color: Colors.black,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => widget.onDeleteSubtask(subtask),
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  void _editAssignment(BuildContext context) {
    if (isProject()) {
      final project = widget.assignment as ProjectAssignment;
      // Ensure onProjectUpdate isn't null in project scenario
      showDialog(
        context: context,
        builder: (context) {
          return ProjectForm(
            project: project,
            onSave: (updatedProject) {
              widget.onProjectUpdate?.call(updatedProject);
              Navigator.pop(context);
            },
          );
        },
      );
    } else {
      final task = widget.assignment as TaskAssignment;
      // Ensure onTaskUpdate isn't null in task scenario
      showDialog(
        context: context,
        builder: (context) {
          return TaskForm(
            task: task,
            onSave: (updatedTask) {
              widget.onTaskUpdate?.call(updatedTask);
              Navigator.pop(context);
              return updatedTask;
            },
          );
        },
      );
    }
  }
}
