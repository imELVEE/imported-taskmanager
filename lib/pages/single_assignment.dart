import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:planner_app/classes/project_assignment.dart';
import 'package:planner_app/classes/task_assignment.dart';

class DetailPage extends StatefulWidget {
  dynamic assignment;
  // assignment can be ProjectAssignment or TaskAssignment
  final List<TaskAssignment> subTasks;

  final Function(ProjectAssignment)? onProjectUpdate;
  final Function(TaskAssignment)? onTaskUpdate;

  final Function(ProjectAssignment, bool?)? onToggleProjectCompletion;
  final Function(TaskAssignment, bool?) onToggleTaskCompletion;
  final Function(TaskAssignment) onEditSubtask;
  final Function(TaskAssignment) onDeleteSubtask;
  final Function(TaskAssignment)? onAddSubtask;
  final Function(ProjectAssignment)? onAddTask;

  DetailPage({
    Key? key,
    required this.assignment,
    required this.subTasks,
    this.onProjectUpdate,
    this.onTaskUpdate,
    this.onToggleProjectCompletion,
    required this.onToggleTaskCompletion,
    required this.onEditSubtask,
    required this.onDeleteSubtask,
    this.onAddSubtask,
    this.onAddTask
  }) : super(key: key);

  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {

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
        backgroundColor: const Color.fromARGB(255, 23, 84, 140),
        child: const Icon(Icons.edit),
        onPressed: () {
          _editAssignment(context);
        },
      ),
    );
  }

  Widget _buildSubList(BuildContext context) {
    Future<void> _addSubtaskLocal() async{
      if (isProject()) {
        TaskAssignment subtask = await widget.onAddTask?.call(widget.assignment);
        setState(() {
          if (subtask != null) {
            widget.subTasks.add(subtask);
          }
        });
      }
      else {
        TaskAssignment subtask = await widget.onAddSubtask?.call(widget.assignment);
        setState(() {
          if (subtask != null) {
            widget.subTasks.add(subtask);
          }
        });
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          const Text(
            'Subtasks',
            style: TextStyle(
                color: Color.fromARGB(255, 23, 84, 140),
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 8),
          for (final subtask in widget.subTasks) _buildSubtaskRow(context, subtask),
          ListTile(
            leading: const Icon(Icons.add, color: Color.fromARGB(255, 23, 84, 140)),
            title: const Text(
              'Add a Subtask',
              style: TextStyle(color: Color.fromARGB(255, 23, 84, 140), fontSize: 16),
            ),
            onTap: () {
              _addSubtaskLocal();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final dynamic thisAssignment;
    if (isProject()) {
      thisAssignment = widget.assignment as ProjectAssignment;
    } else {
      thisAssignment = widget.assignment as TaskAssignment;
    }

    String formattedDueDate = thisAssignment.dueDate == null
        ? 'No Due Date'
        : DateTimeFormat.format(thisAssignment.dueDate!, format: DateTimeFormats.american);

    String formattedCreateDate = DateTimeFormat.format(thisAssignment.createDate!, format: DateTimeFormats.american);

    String formattedCompleteDate = thisAssignment.completeDate == null
        ? 'No Complete Date'
        : DateTimeFormat.format(thisAssignment.completeDate!, format: DateTimeFormats.american);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              fillColor: const WidgetStatePropertyAll(Colors.white),
              side: WidgetStateBorderSide.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const BorderSide(color: Colors.black);
                } else {
                  return const BorderSide(color: Colors.blue);
                }
              }
              ),
              checkColor: Colors.black,
              value: thisAssignment.completed ?? false,
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
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        Text(
          thisAssignment.notes != null && thisAssignment.notes != ''
              ? 'Description: ' + thisAssignment.notes
              : 'No Description',
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
        Text(
          'Due: ${formattedDueDate} | id: ${thisAssignment.id}'
            + (thisAssignment.completed ? '\nCompleted: ${formattedCompleteDate}' : ''),
          style: TextStyle(
            color: thisAssignment.completed ?? false ? Colors.green : Colors.red,
            fontWeight: FontWeight.normal
          )
        ),
        const SizedBox(height: 8),
        Text('Created On: ${formattedCreateDate}',
            style: const TextStyle(
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

    String subtaskCompleteText = subtask.completeDate != null
        ? DateTimeFormat.format(subtask.completeDate!, format: DateTimeFormats.american)
        : "No Complete Date";

    Future<void> _editSubtaskLocal() async {
      subtask = await widget.onEditSubtask(subtask);
      setState(() {
        final index = widget.subTasks.indexWhere((t) => t.id == subtask.id);
        if (index != -1) {
          widget.subTasks[index] = subtask;
        }
      });
    }

    return ListTile(
      leading: Checkbox(
        fillColor: subtask.completed
        ? const WidgetStatePropertyAll(Color.fromARGB(204, 12, 198, 241))
        : const WidgetStatePropertyAll(Colors.white),
        value: subtask.completed,
        onChanged: (value) {
          widget.onToggleTaskCompletion(subtask, value);
          setState(() {
            subtask.completed = value ?? false;
          });
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtask.subject,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtask.notes != null && subtask.notes != ''
              ? 'Description: ${subtask.notes!}'
              : 'No Description',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DUE: ${subtaskDueText}',
            style: TextStyle(
                color: subtask.completed ? Colors.green : Colors.redAccent,
                fontSize: 12
            ),
          ),
          Text(
            subtask.completed ? 'Completed: ${subtaskCompleteText}' : '',
            style: const TextStyle(color: Colors.green, fontSize: 12),
          ),
        ],
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
            onPressed: () {
              widget.onDeleteSubtask(subtask);
              setState(() {
                widget.subTasks.removeWhere((task) => task.id == subtask.id);
              });
            },
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  void _editAssignment(BuildContext context) async{
    if (isProject()) {
      ProjectAssignment project = widget.assignment as ProjectAssignment;
      project = await widget.onProjectUpdate?.call(project);
      setState(() => widget.assignment = project);
    } else {
      TaskAssignment task = widget.assignment as TaskAssignment;
      task = await widget.onTaskUpdate?.call(task);
      setState(() => widget.assignment = task);
    }
  }
}
