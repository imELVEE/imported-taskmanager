import 'package:flutter/material.dart';
import 'package:planner_app/classes/task_assignment.dart';
import './project_widget.dart';
import '../classes/project_assignment.dart';

class ProjectsList extends StatelessWidget {
  final Function(ProjectAssignment) onProjectUpdate;
  final Function(ProjectAssignment) onDelete;
  List<ProjectAssignment> projects;
  final Function(ProjectAssignment, bool?) onToggleProjectCompletion;

  final List<TaskAssignment> allTasks;
  final Function(ProjectAssignment) onAddTask;
  final Function(TaskAssignment, bool?) onToggleTaskCompletion;
  final Function(TaskAssignment) onEditTask;
  final Function(TaskAssignment) onDeleteTask;

  ProjectsList({
    required this.projects,
    required this.onProjectUpdate,
    required this.onDelete,
    required this.allTasks,
    required this.onAddTask,
    required this.onToggleTaskCompletion,
    required this.onToggleProjectCompletion,
    required this.onEditTask,
    required this.onDeleteTask,
    Key? key
  }) : super(key: key);

  void addProject(ProjectAssignment project){
    projects.add(project);
  }

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return ProjectWidget(
            project: projects[index],
            onProjectUpdate: onProjectUpdate,
            onDelete: onDelete,
            allTasks: allTasks,
            onAddTask: onAddTask,
            onToggleTaskCompletion: onToggleTaskCompletion,
          onToggleProjectCompletion: onToggleProjectCompletion,
            onEditTask: onEditTask,
            onDeleteTask: onDeleteTask,
            key: ValueKey(projects[index].id),
        );
      },
    );
  }
}