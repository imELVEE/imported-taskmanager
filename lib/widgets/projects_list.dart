import 'package:flutter/material.dart';
import './project_widget.dart';
import '../classes/project_assignment.dart';

class ProjectsList extends StatelessWidget {
  final Function(ProjectAssignment) onProjectUpdate;
  final Function(ProjectAssignment) onDelete;
  List<ProjectAssignment> projects;

  ProjectsList({
    required this.projects,
    required this.onProjectUpdate,
    required this.onDelete,
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
            key: ValueKey(projects[index].id),
        );
      },
    );
  }
}