class Attorney {
  const Attorney({
    required this.id,
    required this.name,
    required this.title,
    required this.specialization,
    required this.bio,
    required this.credentials,
    required this.education,
    required this.experienceYears,
    required this.email,
    required this.initials,
    required this.priority,
    required this.practiceAreaIds,
  });

  final String id;
  final String name;
  final String title;
  final String specialization;
  final String bio;
  final String credentials;
  final String education;
  final int experienceYears;
  final String email;
  final String initials;
  final int priority;
  final List<String> practiceAreaIds;

  factory Attorney.fromJson(Map<String, dynamic> json, {String? id}) {
    return Attorney(
      id: id ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      credentials: json['credentials'] as String? ?? '',
      education: json['education'] as String? ?? '',
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
      initials: json['initials'] as String? ?? '',
      priority: (json['priority'] as num?)?.toInt() ?? 999,
      practiceAreaIds: (json['practiceAreaIds'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'specialization': specialization,
      'bio': bio,
      'credentials': credentials,
      'education': education,
      'experienceYears': experienceYears,
      'email': email,
      'initials': initials,
      'priority': priority,
      'practiceAreaIds': practiceAreaIds,
    };
  }
}
