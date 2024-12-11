
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

  factory TaskAssignment.fromJson(Map<String, dynamic> json) {
    return TaskAssignment(
      id: json['id'] as String,
      createDate: DateTime.parse(json['createDate'] as String),
      subject: json['subject'] as String,
      notes: json['notes'] as String?,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      completeDate: json['completeDate'] != null ? DateTime.parse(json['completeDate'] as String) : null,
      completed: json['completed'] as bool? ?? false,
      parentId: json['parentId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createDate': createDate.toIso8601String(),
      'subject': subject,
      'notes': notes,
      'dueDate': dueDate?.toIso8601String(),
      'completeDate': completeDate?.toIso8601String(),
      'completed': completed,
      'parentId': parentId,
    };
  }
}