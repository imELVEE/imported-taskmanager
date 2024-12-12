
import 'package:firebase_auth/firebase_auth.dart';

class ProjectAssignment {
  String id;
  DateTime createDate;
  String subject;
  String? notes;
  DateTime? dueDate;

  DateTime? completeDate;
  bool completed;

  ProjectAssignment({
    required this.id,
    required this.createDate,
    required this.subject,
    this.completed = false,
    this.dueDate,
    this.notes,
    this.completeDate,
  });

  factory ProjectAssignment.fromJson(Map<String, dynamic> json) {
    return ProjectAssignment(
      id: json['assignment_id'] as String,
      createDate: DateTime.parse(json['create_date'] as String),
      subject: json['subject'] as String,
      notes: json['notes'] as String?,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      completeDate: json['completed_date'] != null ? DateTime.parse(json['completed_date'] as String) : null,
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': FirebaseAuth.instance.currentUser?.email,
      'create_date': createDate.toIso8601String(),
      'subject': subject,
      'notes': notes,
      'due_date': dueDate?.toIso8601String(),
      'completed_date': completeDate?.toIso8601String(),
      'completed': completed,
    };
  }
}