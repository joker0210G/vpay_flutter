class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;
  final bool isVerified;
  final List<String>? skills;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.phone,
    this.isVerified = false,
    this.skills,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      phone: json['phone'],
      skills: json['skills'] == null ? [] : List<String>.from(json['skills']),
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'phone': phone,
      'skills': skills,
      'is_verified': isVerified,
    };
  }
}

