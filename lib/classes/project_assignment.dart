
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


}