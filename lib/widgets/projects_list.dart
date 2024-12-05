import 'package:flutter/material.dart';
import './project_widget.dart';
import '../classes/project_assignment.dart';

class ProjectsList extends StatelessWidget {
  final List<ProjectAssignment> projects = [
    ProjectAssignment(
      id: 1,
      createDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(hours: 24)),
      subject: 'Flutter Project',
      notes: 'Do Mobile App',
    ),
    ProjectAssignment(
      id: 2,
      createDate: DateTime.now().subtract(const Duration(hours: 8)),
      dueDate: DateTime.now().add(const Duration(hours: 36)),
      subject: 'Some Project 2',
    ),
    ProjectAssignment(
      id: 3,
      createDate: DateTime.now().subtract(const Duration(hours: 39)),
      dueDate: DateTime.now().add(const Duration(hours: 12)),
      subject: 'Some Project 3',
      completed: true,
      notes: 'Do Something.',
    ),
  ];

  ProjectsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return ProjectWidget(
            project: projects[index],
            key: ValueKey(projects[index].id),
        );
      },
    );
  }
}