import 'package:planner_app/classes/project_assignment.dart';
import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class ProjectForm extends StatefulWidget {
  final ProjectAssignment? project;
  final void Function(ProjectAssignment) onSave;

  const ProjectForm({this.project, required this.onSave, Key? key}) : super(key: key);

  @override
  ProjectFormState createState() => ProjectFormState();
}

class ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  ///int id;
  late DateTime _createDate;
  late String _subject;
  String? _notes;
  DateTime? _dueDate;

  DateTime? _completeDate;
  late bool _completed = false;

  int generateIntFromUUID() {
    var uuid = const Uuid();
    String uuidString = uuid.v4();
    final buffer = List<int>.filled(16, 0);
    List<int> rawBytes = uuid.v4buffer(buffer); // Gets a 16-byte list representing the UUID
    // Construct a 64-bit integer from the first 8 bytes:
    int intId = 0;
    for (int i = 0; i < 8; i++) {
      intId = (intId << 8) | rawBytes[i];
    }
    intId = intId & 0x7FFFFFFFFFFFFFFF; //ensure positive

    return intId;
  }

  Future<void> _selectDateTime(BuildContext context, DateTime? currentDate, Function(DateTime) onDatePicked) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2124),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDate ?? DateTime.now()),
      );

      if (pickedTime != null) {
        // Combine selected date and time
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onDatePicked(combinedDateTime);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _subject = widget.project!.subject;
      _createDate = widget.project!.createDate;
      _dueDate = widget.project!.dueDate;
      _notes = widget.project!.notes;
      _completed = widget.project!.completed;
      _completeDate = widget.project!.completeDate;
    }
    else {
      _createDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.project == null ? 'Add Project' : 'Edit Project'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: widget.project?.subject,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _subject = value!;
                },
              ),
              TextFormField(
                initialValue: widget.project?.notes,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _notes = value;
                },
              ),
              GestureDetector(
                onTap: () {
                  _selectDateTime(context, _createDate, (pickedDate) {
                    setState(() {
                      _createDate = pickedDate;
                    });
                  });
                },
                child: AbsorbPointer(  // Prevents manual text input
                  child: TextField(
                    controller: TextEditingController(
                      text: _createDate != null
                          ? _createDate!.format(DateTimeFormats.american)
                          : 'Creation Date',  // Default text
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Create Date',
                      hintText: 'Tap to select a date',
                    ),
                  ),
                ),
              ),
              CheckboxListTile(
                title: const Text('Completed'),
                value: _completed,
                onChanged: (value) {
                  setState(() {
                    _completed = value!;
                    if (!_completed) {
                      _completeDate = null;
                    }
                  });
                },
              ),
              if (_completed)
                GestureDetector(
                  onTap: () {
                    _selectDateTime(context, _completeDate, (pickedDate) {
                      setState(() {
                        _completeDate = pickedDate;
                      });
                    });
                  },
                  child: AbsorbPointer(  // Prevents manual text input
                    child: TextField(
                      controller: TextEditingController(
                        text: _completeDate != null
                          ? _completeDate!.format(DateTimeFormats.american)
                          : 'Select completion date',  // Default text
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Completion Date',
                        hintText: 'Tap to select a date',
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  _selectDateTime(context, _dueDate, (pickedDate) {
                    setState(() {
                      _dueDate = pickedDate;
                    });
                  });
                },
                child: AbsorbPointer(  // Prevents manual text input
                  child: TextField(
                    controller: TextEditingController(
                      text: _dueDate != null
                          ? _dueDate!.format(DateTimeFormats.american)
                          : 'Due Date',  // Default text
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Due Date',
                      hintText: 'Tap to select a date',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newProject = ProjectAssignment(
                id: widget.project?.id ?? generateIntFromUUID(),
                subject: _subject,
                notes: _notes,
                completed: _completed,
                dueDate: _dueDate,
                createDate: _createDate,
              );
              widget.onSave(newProject);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}