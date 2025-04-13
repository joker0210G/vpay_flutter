import 'package:flutter/material.dart';
import 'package:vpay/shared/models/task_model.dart';

class TaskFilterDialog extends StatefulWidget {
  final TaskFilter? initialFilter;

  const TaskFilterDialog({
    super.key,
    this.initialFilter,
  });

  @override
  State<TaskFilterDialog> createState() => _TaskFilterDialogState();
}

class _TaskFilterDialogState extends State<TaskFilterDialog> {
  late TaskStatus? _selectedStatus;
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();
  final List<String> _skills = [];
  String _newSkill = '';

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialFilter?.status;
    _minAmountController.text = widget.initialFilter?.minAmount?.toString() ?? '';
    _maxAmountController.text = widget.initialFilter?.maxAmount?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Tasks'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<TaskStatus>(
            value: _selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Status',
            ),
            items: TaskStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            children: _skills.map((skill) => Chip(
              label: Text(skill),
              onDeleted: () {
                setState(() {
                  _skills.remove(skill);
                });
              },
            )).toList(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Add Skill',
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Add Skill'),
                        content: TextFormField(
                          onChanged: (value) => _newSkill = value,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                                                      TextButton(
                                onPressed: () {
                                  if (_newSkill.isNotEmpty) {
                                    setState(() {
                                      _skills.add(_newSkill);
                                      _newSkill = '';
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                            child: const Text('Apply'),
                          )
                        ],
                      );
                    });
                },
              )
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _minAmountController,
            decoration: const InputDecoration(
              labelText: 'Minimum Amount',
              prefixText: '₹ ',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _maxAmountController,
            decoration: const InputDecoration(
              labelText: 'Maximum Amount',
              prefixText: '₹ ',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final filter = TaskFilter(
              status: _selectedStatus,
              minAmount: double.tryParse(_minAmountController.text),
              maxAmount: double.tryParse(_maxAmountController.text),
              skills: _skills,
            );
            Navigator.pop(context, filter);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }
}