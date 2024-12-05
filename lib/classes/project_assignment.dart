import 'package:flutter/material.dart';

class ProjectAssignment {
  int id;
  DateTime createDate;
  String subject;
  String? notes;
  DateTime dueDate;

  DateTime? completeDate;
  bool completed;
  int members;

  ProjectAssignment({
    required this.id,
    required this.createDate,
    required this.dueDate,
    required this.subject,
    required this.members,
    this.completed = false,
    this.notes,
    this.completeDate,
  });


}