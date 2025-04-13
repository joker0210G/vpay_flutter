class Task {
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

  Task({
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
  });

    factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      amount: map['amount'] ?? 0.0,
      deadline: DateTime.parse(map['deadline']),
      creatorId: map['creatorId'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      createdAt: DateTime.parse(map['createdAt']),
      skills: List<String>.from(map['skills']),
    );
  }
}
