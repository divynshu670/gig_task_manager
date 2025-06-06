import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';

class AddEditTaskPage extends ConsumerStatefulWidget {
  final Task? existingTask;

  const AddEditTaskPage({Key? key, this.existingTask}) : super(key: key);

  @override
  ConsumerState<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends ConsumerState<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  Priority _currentPriority = Priority.low;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      final t = widget.existingTask!;
      _titleController = TextEditingController(text: t.title);
      _descriptionController = TextEditingController(text: t.description);
      _selectedDate = t.dueDate;
      _currentPriority = t.priority;
      _isCompleted = t.isCompleted;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _selectedDate = DateTime.now();
      _currentPriority = Priority.low;
      _isCompleted = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: today.subtract(const Duration(days: 365)),
      lastDate: today.add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleController.text.trim();
    final desc = _descriptionController.text.trim();
    final dueDate = _selectedDate!;
    final priority = _currentPriority;
    final isCompleted = _isCompleted;

    final id = widget.existingTask?.id ?? const Uuid().v4();
    final newTask = Task(
      id: id,
      title: title,
      description: desc,
      dueDate: dueDate,
      priority: priority,
      isCompleted: isCompleted,
    );

    final addTaskUC = ref.read(addTaskUseCaseProvider);
    final editTaskUC = ref.read(editTaskUseCaseProvider);

    if (widget.existingTask != null) {
      // EDIT
      editTaskUC(newTask).then((_) {
        Navigator.of(context).pop();
      });
    } else {
      // CREATE
      addTaskUC(newTask).then((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTask != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              // Due Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due Date'),
                subtitle: Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Select a date',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              // Priority Dropdown
              DropdownButtonFormField<Priority>(
                value: _currentPriority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: Priority.values
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(
                            p.name[0].toUpperCase() + p.name.substring(1),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _currentPriority = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              // Completed checkbox (visible only in edit mode)
              if (isEditing)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isCompleted,
                  title: const Text('Completed'),
                  onChanged: (val) {
                    setState(() {
                      _isCompleted = val ?? false;
                    });
                  },
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text(isEditing ? 'Update Task' : 'Create Task'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
