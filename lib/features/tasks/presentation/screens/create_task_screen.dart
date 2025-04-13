import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vpay/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:vpay/shared/models/task_model.dart';
import 'package:uuid/uuid.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? _selectedDeadline;
  final List<String> _skills = [];
  final _skillController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          if (value.length < 3) {
                            return 'The title must be at least 3 characters';
                          }
                          if (value.length > 50) {
                            return 'The title must be less than 50 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length < 5) {
                            return 'The description must be at least 5 characters';
                          }
                          if (value.length > 100) {
                            return 'The description must be less than 100 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a value greater than 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _skillController,
                        decoration: const InputDecoration(
                          labelText: 'Skill',
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            _skills.add(value);
                          });
                          _skillController.clear();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_skills.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please add at least one skill')),
                              );
                              return;
                            }
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              final task = Task(
                                // ignore: prefer_const_constructors
                                id: Uuid().v4(),
                                title: _titleController.text,
                                description: _descriptionController.text,
                                amount: double.parse(_amountController.text),
                                deadline: _selectedDeadline!,
                                creatorId: '',
                                createdAt: DateTime.now(),
                                skills: _skills,
                                latitude: 0,
                                longitude: 0,
                              );
                              await ref
                                  .read(tasksProvider.notifier)
                                  .createTask(task);
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Text('Create Task'),
                      ),
                      const SizedBox(height: 20),
                      const Text('Skills:'),
                      Wrap(
                        children: _skills
                            .map((skill) => Chip(label: Text(skill)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
