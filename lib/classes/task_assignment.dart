import 'package:firebase_auth/firebase_auth.dart';

class TaskAssignment {
  String id;
  DateTime createDate;
  String subject;
  String? notes;
  DateTime? dueDate;

  DateTime? completeDate;
  bool completed;

  String? parentId; // Null for top-level tasks, or the id of the parent task

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

  TaskAssignment copyWith({
    bool? completed,
    DateTime? completeDate,
    String? subject,
    String? notes,
    DateTime? dueDate,
    String? parentId,
  }) {
    return TaskAssignment(
      id: id,
      parentId: parentId ?? this.parentId,
      createDate: createDate,
      dueDate: dueDate ?? this.dueDate,
      subject: subject ?? this.subject,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
      completeDate: completeDate ?? this.completeDate,
    );
  }

  factory TaskAssignment.fromTaskJson(Map<String, dynamic> json) {
    print('TASKSJSON: ${json['tasks']}');
    return TaskAssignment(
      id: json['assignment_id'] as String,
      createDate: DateTime.parse(json['create_date'] as String),
      subject: json['subject'] as String,
      notes: json['notes'] as String?,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      completeDate: json['tasks']['completed_date'] != null ? DateTime.parse(json['tasks']['completed_date'] as String) : null,
      completed: json['tasks']['completed'] as bool? ?? false,
      parentId: json['parentId'] as String?,
    );
  }

  Map<String, dynamic> toTaskJson() {
    return {
      'email': FirebaseAuth.instance.currentUser?.email,
      'create_date': createDate.toIso8601String(),
      'subject': subject,
      'notes': notes,
      'due_date': dueDate?.toIso8601String(),
      'completed': completed,
      'parent_task': parentId,
    };
  }

  factory TaskAssignment.fromProjectJson(Map<String, dynamic> json) {
    print('TASKSJSON: ${json['tasks']}');
    return TaskAssignment(
      id: json['assignment_id'] as String,
      createDate: DateTime.parse(json['create_date'] as String),
      subject: json['subject'] as String,
      notes: json['notes'] as String?,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      completeDate: json['tasks']['completed_date'] != null ? DateTime.parse(json['tasks']['completed_date'] as String) : null,
      completed: json['tasks']['completed'] as bool? ?? false,
      parentId: json['tasks']['parent_project'] as String?,
    );
  }

  Map<String, dynamic> toProjectJson() {
    return {
      'email': FirebaseAuth.instance.currentUser?.email,
      'create_date': createDate.toIso8601String(),
      'subject': subject,
      'notes': notes,
      'due_date': dueDate?.toIso8601String(),
      'completed': completed,
      'parent_project': parentId,
    };
  }
}