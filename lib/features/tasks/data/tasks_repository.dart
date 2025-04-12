import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpay/shared/models/task_model.dart';

final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  return TasksRepository(supabase: Supabase.instance.client);
});

class TasksRepository {
  final SupabaseClient supabase;

  TasksRepository({required this.supabase});

  Future<List<TaskModel>> getTasks() async {
    final response = await supabase
        .from('tasks')
        .select()
        .order('created_at', ascending: false);
    
    return response.map((task) => TaskModel.fromJson(task)).toList();
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await supabase
        .from('tasks')
        .insert(task.toJson())
        .select()
        .single();
    
    return TaskModel.fromJson(response);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await supabase
        .from('tasks')
        .update(task.toJson())
        .eq('id', task.id)
        .select()
        .single();
    
    return TaskModel.fromJson(response);
  }

  Stream<List<TaskModel>> streamNearbyTasks(double latitude, double longitude, double radiusInKm) {
    return supabase
        .from('tasks')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((events) => events.map((task) => TaskModel.fromJson(task)).toList());
  }

  Future<List<TaskModel>> getFilteredTasks({
    TaskStatus? status,
    double? minAmount,
    double? maxAmount,
    double? latitude,
    double? longitude,
    double? radiusKm,
  }) async {
    var query = supabase
        .from('tasks')
        .select();

    if (status != null) {
      query = query.eq('status', status.toString().split('.').last);
    }
    
    if (minAmount != null) {
      query = query.gte('amount', minAmount);
    }
    
    if (maxAmount != null) {
      query = query.lte('amount', maxAmount);
    }

    final response = await query.order('created_at', ascending: false);
    return response.map((task) => TaskModel.fromJson(task)).toList();
  }

  Stream<List<TaskModel>> streamTasks() {
    return supabase
        .from('tasks')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((events) => events.map((task) => TaskModel.fromJson(task)).toList());
  }
}

