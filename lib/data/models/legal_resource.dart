class LegalResource {
  const LegalResource({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.category,
    required this.readTimeMinutes,
    required this.priority,
    required this.publishedDate,
  });

  final String id;
  final String title;
  final String summary;
  final String body;
  final String category;
  final int readTimeMinutes;
  final int priority;
  final String publishedDate;

  factory LegalResource.fromJson(Map<String, dynamic> json, {String? id}) {
    return LegalResource(
      id: id ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      body: json['body'] as String? ?? '',
      category: json['category'] as String? ?? '',
      readTimeMinutes: (json['readTimeMinutes'] as num?)?.toInt() ?? 1,
      priority: (json['priority'] as num?)?.toInt() ?? 999,
      publishedDate: json['publishedDate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'body': body,
      'category': category,
      'readTimeMinutes': readTimeMinutes,
      'priority': priority,
      'publishedDate': publishedDate,
    };
  }
}
