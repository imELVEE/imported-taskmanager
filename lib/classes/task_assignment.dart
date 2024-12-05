import 'package:flutter/material.dart';

class TaskAssignment {
  int id;
  DateTime createDate;
  String subject;
  String? notes;
  DateTime dueDate;

  DateTime? completeDate;
  bool completed;

  TaskAssignment({
    required this.id,
    required this.createDate,
    required this.dueDate,
    required this.subject,
    this.completed = false,
    this.notes,
    this.completeDate,
  });


}