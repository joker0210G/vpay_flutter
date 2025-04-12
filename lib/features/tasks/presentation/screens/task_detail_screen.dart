import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vpay/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:vpay/shared/models/task_model.dart';
import 'package:vpay/features/chat/presentation/screens/chat_screen.dart';
import 'package:vpay/features/auth/presentation/providers/auth_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  final TaskModel task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withAlpha(25), // Changed from withOpacity
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${task.amount}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection('Description', task.description),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    'Deadline',
                    task.deadline.toString().split('.').first,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    'Status',
                    task.status.toString().split('.').last.toUpperCase(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: task.status == TaskStatus.open
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => _applyForTask(context, ref),
                  child: const Text('Apply for Task'),
                ),
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final currentUserId = ref.read(authProvider).user!.id;
          final otherUserId = task.creatorId == currentUserId
              ? task.assigneeId!
              : task.creatorId;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                task: task,
                currentUserId: currentUserId,
                otherUserId: otherUserId,
              ),
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(content),
      ],
    );
  }

  void _applyForTask(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(authProvider).user;
    if (currentUser == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Task'),
        content: const Text('Are you sure you want to apply for this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Update task status and assignee
              final updatedTask = TaskModel(
                id: task.id,
                title: task.title,
                description: task.description,
                creatorId: task.creatorId,
                assigneeId: currentUser.id,
                amount: task.amount,
                createdAt: task.createdAt,
                deadline: task.deadline,
                status: TaskStatus.inProgress,
                latitude: task.latitude,
                longitude: task.longitude,
                tags: task.tags,
              );

              await ref.read(tasksProvider.notifier).updateTask(updatedTask);
              
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to task list
              }
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

