import 'package:flutter/material.dart';
import 'package:planner_app/widgets/task_widget.dart';
import 'package:planner_app/classes/task_assignment.dart';

class TasksList extends StatelessWidget {
  final Function(TaskAssignment) onTaskUpdate;
  final Function(TaskAssignment) onDelete;
  final void Function(TaskAssignment parentTask) onAddSubtask;
  final void Function(TaskAssignment subtask, bool? value) onToggleSubtask;
  final void Function(TaskAssignment subtask) onEditSubtask;
  final void Function(TaskAssignment subtask) onDeleteSubtask;
  final Function(TaskAssignment, bool?) onToggleTaskCompletion;
  List<TaskAssignment> tasks; // parent tasks only
  final List<TaskAssignment> allTasks;      // All tasks, including subtasks

  TasksList({
    required this.tasks,
    required this.allTasks,
    required this.onTaskUpdate,
    required this.onDelete,
    required this.onAddSubtask,
    required this.onToggleSubtask,
    required this.onEditSubtask,
    required this.onDeleteSubtask,
    required this.onToggleTaskCompletion,
    Key? key
  }) : super(key: key);

  void addTask(TaskAssignment task){
    tasks.add(task);
  }

  @override
  Widget build(BuildContext context){
    final topLevelTasks = allTasks.where((task) => task.parentId == null).toList();

    return ListView.builder(
      itemCount: topLevelTasks.length,
      itemBuilder: (context, index) {
        return TaskWidget(
          task: topLevelTasks[index],
          allTasks: allTasks,
          onTaskUpdate: onTaskUpdate,
          onDelete: onDelete,
          key: ValueKey(tasks[index].id),
          onAddSubtask: onAddSubtask,
          onToggleSubtask: onToggleSubtask,
          onEditSubtask: onEditSubtask,
          onDeleteSubtask: onDeleteSubtask,
          onToggleTaskCompletion: onToggleTaskCompletion,
        );
      },
    );
  }
}