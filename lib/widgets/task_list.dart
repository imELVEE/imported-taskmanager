import 'package:flutter/material.dart';
import 'package:planner_app/widgets/task_widget.dart';
import 'package:planner_app/classes/task_assignment.dart';

class TasksList extends StatelessWidget {
  final Function(TaskAssignment) onTaskUpdate;
  final Function(TaskAssignment) onDelete;
  List<TaskAssignment> tasks;

  TasksList({
    required this.tasks,
    required this.onTaskUpdate,
    required this.onDelete,
    Key? key
  }) : super(key: key);

  void addTask(TaskAssignment task){
    tasks.add(task);
  }

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskWidget(
          task: tasks[index],
          onTaskUpdate: onTaskUpdate,
          onDelete: onDelete,
          key: ValueKey(tasks[index].id),
        );
      },
    );
  }
}