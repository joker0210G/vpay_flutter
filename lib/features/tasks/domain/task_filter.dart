import 'package:vpay/features/tasks/domain/task_status.dart';

class TaskFilter {
  final TaskStatus? status;
  final double? minAmount;
  final double? maxAmount;
  final double? latitude;
  final double? longitude;
  final double? radiusKm;
  final List<String>? skills;

  const TaskFilter({
    this.status,
    this.minAmount,
    this.maxAmount,
    this.latitude,
    this.longitude,
    this.skills,
    this.radiusKm,
  });

  TaskFilter copyWith({
    TaskStatus? status,
    double? minAmount,
    double? maxAmount,
    double? latitude,
    double? longitude,
    double? radiusKm,
    List<String>? skills
  }) {
    return TaskFilter(
      status: status ?? this.status,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      skills: skills ?? this.skills,
      radiusKm: radiusKm ?? this.radiusKm,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status?.toString().split('.').last,
      'min_amount': minAmount,
      'max_amount': maxAmount,
      'latitude': latitude,
      'longitude': longitude,
      'radius_km': radiusKm,
      'skills': skills,
    };
  }

  factory TaskFilter.fromJson(Map<String, dynamic> json) {
    return TaskFilter(
      status: json['status'] != null 
          ? TaskStatus.values.firstWhere(
              (e) => e.toString().split('.').last == json['status'])
          : null,
      minAmount: json['min_amount']?.toDouble(),
      maxAmount: json['max_amount']?.toDouble(),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      radiusKm: json['radius_km']?.toDouble(),
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null
    );
  }
}