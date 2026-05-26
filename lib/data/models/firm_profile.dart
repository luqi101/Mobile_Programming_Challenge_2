class FirmProfile {
  const FirmProfile({
    required this.name,
    required this.tagline,
    required this.overview,
    required this.mission,
    required this.values,
    required this.whyChooseUs,
    required this.stats,
    required this.phone,
    required this.email,
    required this.address,
    required this.disclaimer,
  });

  final String name;
  final String tagline;
  final String overview;
  final String mission;
  final List<String> values;
  final List<String> whyChooseUs;
  final List<FirmStat> stats;
  final String phone;
  final String email;
  final String address;
  final String disclaimer;

  factory FirmProfile.fromJson(Map<String, dynamic> json) {
    return FirmProfile(
      name: json['name'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      mission: json['mission'] as String? ?? '',
      values: _stringList(json['values']),
      whyChooseUs: _stringList(json['whyChooseUs']),
      stats: (json['stats'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(FirmStat.fromJson)
          .toList(),
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      disclaimer: json['disclaimer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tagline': tagline,
      'overview': overview,
      'mission': mission,
      'values': values,
      'whyChooseUs': whyChooseUs,
      'stats': stats.map((stat) => stat.toJson()).toList(),
      'phone': phone,
      'email': email,
      'address': address,
      'disclaimer': disclaimer,
    };
  }
}

class FirmStat {
  const FirmStat({required this.label, required this.value});

  final String label;
  final String value;

  factory FirmStat.fromJson(Map<String, dynamic> json) {
    return FirmStat(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'label': label, 'value': value};
}

List<String> _stringList(Object? value) {
  return (value as List<dynamic>? ?? []).whereType<String>().toList();
}
