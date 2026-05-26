class RepresentativeMatter {
  const RepresentativeMatter({
    required this.id,
    required this.title,
    required this.summary,
    required this.practiceAreaId,
    required this.priority,
    required this.disclaimer,
  });

  final String id;
  final String title;
  final String summary;
  final String practiceAreaId;
  final int priority;
  final String disclaimer;

  factory RepresentativeMatter.fromJson(
    Map<String, dynamic> json, {
    String? id,
  }) {
    return RepresentativeMatter(
      id: id ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      practiceAreaId: json['practiceAreaId'] as String? ?? '',
      priority: (json['priority'] as num?)?.toInt() ?? 999,
      disclaimer: json['disclaimer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'practiceAreaId': practiceAreaId,
      'priority': priority,
      'disclaimer': disclaimer,
    };
  }
}
