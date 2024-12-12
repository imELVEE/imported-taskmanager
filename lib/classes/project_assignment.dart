
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
      completeDate: json['projects']['completed_date'] != null ? DateTime.parse(json['projects']['completed_date'] as String) : null,
      completed: json['projects']['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': FirebaseAuth.instance.currentUser?.email,
      'subject': subject,
      'notes': notes,
      'due_date': dueDate?.toIso8601String(),
      'completed': completed,
    };
  }
}