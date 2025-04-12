enum TaskStatus { open, inProgress, completed, cancelled }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String creatorId;
  final String? assigneeId;
  final double amount;
  final DateTime createdAt;
  final DateTime deadline;
  final TaskStatus status;
  final double? latitude;
  final double? longitude;
  final List<String> tags;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    this.assigneeId,
    required this.amount,
    required this.createdAt,
    required this.deadline,
    this.status = TaskStatus.open,
    this.latitude,
    this.longitude,
    this.tags = const [],
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      creatorId: json['creator_id'],
      assigneeId: json['assignee_id'],
      amount: json['amount'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      deadline: DateTime.parse(json['deadline']),
      status: TaskStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'creator_id': creatorId,
      'assignee_id': assigneeId,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'status': status.toString().split('.').last,
      'latitude': latitude,
      'longitude': longitude,
      'tags': tags,
    };
  }
}

