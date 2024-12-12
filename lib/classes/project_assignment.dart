
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
      id: json['id'] as String,
      createDate: DateTime.parse(json['createDate'] as String),
      subject: json['subject'] as String,
      notes: json['notes'] as String?,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      completeDate: json['completeDate'] != null ? DateTime.parse(json['completeDate'] as String) : null,
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': FirebaseAuth.instance.currentUser?.email,
      'createDate': createDate.toIso8601String(),
      'subject': subject,
      'notes': notes,
      'dueDate': dueDate?.toIso8601String(),
      'completeDate': completeDate?.toIso8601String(),
      'completed': completed,
    };
  }
}