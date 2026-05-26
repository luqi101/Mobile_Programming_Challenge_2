class FaqItem {
  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.priority,
  });

  final String id;
  final String question;
  final String answer;
  final String category;
  final int priority;

  factory FaqItem.fromJson(Map<String, dynamic> json, {String? id}) {
    return FaqItem(
      id: id ?? json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      category: json['category'] as String? ?? '',
      priority: (json['priority'] as num?)?.toInt() ?? 999,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'category': category,
      'priority': priority,
    };
  }
}
