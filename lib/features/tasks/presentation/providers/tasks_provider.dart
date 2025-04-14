import 'dart:async'; // Add this import for StreamSubscription
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vpay/features/tasks/data/tasks_repository.dart';
import 'package:vpay/shared/models/task_model.dart';
import 'package:vpay/features/tasks/domain/task_filter.dart'; // Add this import

final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return TasksNotifier(repository);
});

class TasksNotifier extends StateNotifier<TasksState> {
  final TasksRepository _repository;
  StreamSubscription<List<TaskModel>>? _tasksSubscription;

  TasksNotifier(this._repository) : super(TasksState.initial()) {
    loadTasks();
    _setupTasksListener();
  }

  void _setupTasksListener() {
    _tasksSubscription?.cancel();
    _tasksSubscription = _repository.streamTasks().listen(
      (tasks) {
        state = state.copyWith(tasks: tasks);
      },
      onError: (error) {
        state = state.copyWith(error: "An error occurred while loading tasks.");
      },
    );
  }

  Future<void> loadTasks({TaskFilter? filter}) async {
    state = state.copyWith(isLoading: true);
    try {
      final tasks = await _repository.getFilteredTasks(
        status: filter?.status,
        minAmount: filter?.minAmount,
        maxAmount: filter?.maxAmount,
        latitude: filter?.latitude,
        longitude: filter?.longitude,
        radiusKm: filter?.radiusKm,
      );
      state = state.copyWith(
        tasks: tasks,
        isLoading: false,
        currentFilter: filter,
      );
    } catch (e) {
      state = state.copyWith(
        error: "An error occurred while loading tasks.",
        isLoading: false,
      );
    }
  }

  Future<void> createTask(TaskModel task) async {
    state = state.copyWith(isLoading: true);
    try {
      final newTask = await _repository.createTask(task);
      state = state.copyWith(
        tasks: [newTask, ...state.tasks],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: "An error occurred while creating task.",
        isLoading: false,
      );
    }
  }

  Future<void> updateTask(TaskModel task) async {
    state = state.copyWith(isLoading: true);
    try {
      final updatedTask = await _repository.updateTask(task);
      state = state.copyWith(
        tasks: state.tasks.map((t) => t.id == task.id ? updatedTask : t).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: "An error occurred while updating task.",
        isLoading: false,
      );
    }
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }
}

class TasksState {
  final List<TaskModel> tasks;
  final bool isLoading;
  final String? error;
  final TaskFilter? currentFilter;

  TasksState({
    required this.tasks,
    required this.isLoading,
    this.error,
    this.currentFilter,
  });

  factory TasksState.initial() => TasksState(
    tasks: [],
    isLoading: false,
  );

  TasksState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? error,
    TaskFilter? currentFilter,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

