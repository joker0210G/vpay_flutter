import 'package:vpay/features/tasks/domain/task_status.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime deadline;
  final String creatorId;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final List<String> skills;
  final TaskStatus status;
  final List<String> tags;
  final String? assigneeId;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.deadline,
    required this.creatorId,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.skills,
    required this.status,
    this.tags = const [],
    this.assigneeId,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      deadline: DateTime.parse(map['deadline']),
      creatorId: map['creatorId'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(map['createdAt']),
      skills: List<String>.from(map['skills'] ?? []),
      status: map['status'] != null
          ? TaskStatus.values
              .firstWhere((e) => e.toString().split('.').last == map['status'])
          : TaskStatus.pending,
      tags: List<String>.from(map['tags'] ?? []),
      assigneeId: map['assigneeId'],
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'deadline': deadline.toIso8601String(),
      'creatorId': creatorId,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'skills': skills,
      'status': status.toString().split('.').last,
      'tags': tags,
      'assigneeId': assigneeId,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel.fromMap(json);
  }
}
