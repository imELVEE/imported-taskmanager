import 'package:flutter/material.dart';

class TaskAssignment {
  int id;
  DateTime createDate;
  String subject;
  String? notes;
  DateTime? dueDate;

  DateTime? completeDate;
  bool completed;

  final int? parentId; // Null for top-level tasks, or the id of the parent task

  TaskAssignment({
    required this.id,
    required this.createDate,
    required this.subject,
    this.completed = false,
    this.dueDate,
    this.notes,
    this.completeDate,
    this.parentId,
  });


}