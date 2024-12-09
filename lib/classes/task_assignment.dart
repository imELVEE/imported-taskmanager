
class TaskAssignment {
  int id;
  DateTime createDate;
  String subject;
  String? notes;
  DateTime? dueDate;

  DateTime? completeDate;
  bool completed;

  int? parentId; // Null for top-level tasks, or the id of the parent task

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
    String? subject,
    String? notes,
    DateTime? dueDate,
    int? parentId,
  }) {
    return TaskAssignment(
      id: id,
      parentId: parentId ?? this.parentId,
      createDate: createDate,
      dueDate: dueDate ?? this.dueDate,
      subject: subject ?? this.subject,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
      completeDate: completeDate,
    );
  }
}