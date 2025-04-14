import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vpay/features/analytics/providers/analytics_service_provider.dart';
import 'package:vpay/features/tasks/domain/task_status.dart';
import 'package:vpay/shared/models/task_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:vpay/shared/services/analytics_service.dart';

final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  return TasksRepository(
    supabase: Supabase.instance.client,
    analyticsService: ref.read(analyticsServiceProvider),
  );
});

class TasksRepository {
  final SupabaseClient supabase;
  final AnalyticsService analyticsService;

  TasksRepository({required this.supabase, required this.analyticsService});
  

  Future<List<TaskModel>> getTasks() async {
    final response = await supabase
        .from('tasks').select().order('created_at', ascending: false);

    return response.map((task) => TaskModel.fromJson(task)).toList();
  }

  Future<List<TaskModel>> getTasksInRadius(
      double latitude, double longitude, double radius) async {
    const distance = Distance();
    final List<TaskModel> allTasks = await getTasks();
    final List<TaskModel> tasksInRadius = [];
    for (final task in allTasks) {
      final taskLocation = LatLng(task.latitude, task.longitude);
      final userLocation = LatLng(latitude, longitude);

      final taskDistance =
          distance(userLocation, taskLocation) / 1000; // Convert to km

      if (taskDistance <= radius) {
        tasksInRadius.add(task);
      }
    }
    return tasksInRadius;
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await supabase
        .from('tasks')
        .insert(task.toJson())
        .select()
        .single();   
    final newTask = TaskModel.fromJson(response);
    await analyticsService.logEvent(
          eventName: 'task_created',
          parameters: {
            'task_id': newTask.id,
            'task_title': newTask.title,
            'task_amount': newTask.amount,
            'task_status': newTask.status.toString(),
            'task_creator': newTask.creatorId
          },
        );
    return newTask;
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
    List<String>? skills,
  }) async {
    if (latitude != null && longitude != null && radiusKm != null) {
      return getTasksInRadius(latitude, longitude, radiusKm);
    } else {
      var query = supabase.from('tasks').select();
      

      if (status != null) {
        query = query.eq('status', status.toString().split('.').last);
      }

      if (minAmount != null) {
        query = query.gte('amount', minAmount);
      }

      if (maxAmount != null) {
        query = query.lte('amount', maxAmount);
      }
      
      if (skills != null && skills.isNotEmpty) {
         query = query.filter('skills', 'cs', '{${skills.join(',')}}');
          // only return tasks that have all the skills that the user specified
      }
      


      final response = await query.order('created_at', ascending: false);
      return response.map((task) => TaskModel.fromJson(task)).toList();
    }
  }

  double calculateDistance(LatLng location1, LatLng location2) {
    const distance = Distance();
    return distance(location1, location2) / 1000;

  }

  Stream<List<TaskModel>> streamTasks() {
    return supabase
        .from('tasks')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((events) => events.map((task) => TaskModel.fromJson(task)).toList());
  }
}

