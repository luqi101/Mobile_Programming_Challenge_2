class PracticeArea {
  const PracticeArea({
    required this.id,
    required this.title,
    required this.shortSummary,
    required this.description,
    required this.iconKey,
    required this.priority,
    required this.featured,
  });

  final String id;
  final String title;
  final String shortSummary;
  final String description;
  final String iconKey;
  final int priority;
  final bool featured;

  factory PracticeArea.fromJson(Map<String, dynamic> json, {String? id}) {
    return PracticeArea(
      id: id ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      shortSummary: json['shortSummary'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconKey: json['iconKey'] as String? ?? 'gavel',
      priority: (json['priority'] as num?)?.toInt() ?? 999,
      featured: json['featured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'shortSummary': shortSummary,
      'description': description,
      'iconKey': iconKey,
      'priority': priority,
      'featured': featured,
    };
  }
}
