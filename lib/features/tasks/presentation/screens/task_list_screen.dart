import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vpay/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:vpay/shared/models/task_model.dart';
import 'package:vpay/features/tasks/presentation/screens/create_task_screen.dart';
import 'package:vpay/features/tasks/presentation/widgets/task_filter_dialog.dart';
import 'package:vpay/features/tasks/domain/task_filter.dart'; // Add this import
import 'package:vpay/features/tasks/presentation/screens/task_detail_screen.dart'; // Add this import
import 'package:vpay/features/tasks/domain/task_status.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final filter = await showDialog<TaskFilter>(
                context: context,
                builder: (context) => TaskFilterDialog(
                  initialFilter: ref.read(tasksProvider).currentFilter,
                ),
              );
              if (filter != null) {
                ref.read(tasksProvider.notifier).loadTasks(filter: filter);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(tasksProvider.notifier).loadTasks();
            },
          ),
        ],
      ),
      body: tasksState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasksState.error != null
              ? Center(child: Text(tasksState.error!))
              : ListView.builder(
                  itemCount: tasksState.tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasksState.tasks[index];
                    return TaskCard(task: task);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(task.title),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₹${task.amount}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              task.status.toString().split('.').last,
              style: TextStyle(
                color: _getStatusColor(task.status),
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: task),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.green;
      case TaskStatus.in_progress:
        return Colors.orange;
      case TaskStatus.completed:
        return Colors.blue;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }
}

