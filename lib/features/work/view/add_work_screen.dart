import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/data/models/task_model.dart';
import 'package:my_app/providers/work_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddWorkScreen extends StatefulWidget {
  const AddWorkScreen({super.key});

  @override
  State<AddWorkScreen> createState() => _AddWorkScreenState();
}

class _AddWorkScreenState extends State<AddWorkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _uuid = const Uuid();

  String _selectedProject = 'p1';
  TaskPriority _selectedPriority = TaskPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveWork() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<WorkProvider>();

      final newTask = TaskModel(
        id: _uuid.v4(),
        title: _titleController.text,
        projectId: _selectedProject,
        priority: _selectedPriority,
        status: TaskStatus.planned,
      );

      provider.addTask(newTask);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Work added successfully!')));

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Work"),
        actions: [
          TextButton(
            onPressed: _saveWork,
            child: const Text(
              "Save",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Work Title',
                  hintText: 'e.g. Implemented login API',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: _selectedProject,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'p1', child: Text('ChatUAPP')),
                  DropdownMenuItem(value: 'p2', child: Text('POS System')),
                  DropdownMenuItem(value: 'p3', child: Text('Ecommerce')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedProject = val);
                },
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<TaskPriority>(
                initialValue: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: TaskPriority.values.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(p.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPriority = val);
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveWork,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Save Work"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
