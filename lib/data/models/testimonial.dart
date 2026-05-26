class ClientTestimonial {
  const ClientTestimonial({
    required this.id,
    required this.clientInitials,
    required this.serviceArea,
    required this.quote,
    required this.rating,
    required this.priority,
  });

  final String id;
  final String clientInitials;
  final String serviceArea;
  final String quote;
  final int rating;
  final int priority;

  factory ClientTestimonial.fromJson(Map<String, dynamic> json, {String? id}) {
    return ClientTestimonial(
      id: id ?? json['id'] as String? ?? '',
      clientInitials: json['clientInitials'] as String? ?? '',
      serviceArea: json['serviceArea'] as String? ?? '',
      quote: json['quote'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      priority: (json['priority'] as num?)?.toInt() ?? 999,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientInitials': clientInitials,
      'serviceArea': serviceArea,
      'quote': quote,
      'rating': rating,
      'priority': priority,
    };
  }
}
