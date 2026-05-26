import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/attorney.dart';
import '../models/faq_item.dart';
import '../models/firm_profile.dart';
import '../models/legal_resource.dart';
import '../models/practice_area.dart';
import '../models/representative_matter.dart';
import '../models/testimonial.dart';

class PortfolioSeed {
  const PortfolioSeed({
    required this.firmProfile,
    required this.practiceAreas,
    required this.attorneys,
    required this.representativeMatters,
    required this.testimonials,
    required this.resources,
    required this.faqs,
  });

  final FirmProfile firmProfile;
  final List<PracticeArea> practiceAreas;
  final List<Attorney> attorneys;
  final List<RepresentativeMatter> representativeMatters;
  final List<ClientTestimonial> testimonials;
  final List<LegalResource> resources;
  final List<FaqItem> faqs;
}

class SeedLoader {
  const SeedLoader({this.assetPath = 'assets/data/portfolio_seed.json'});

  final String assetPath;

  Future<PortfolioSeed> load() async {
    final jsonText = await rootBundle.loadString(assetPath);
    final data = jsonDecode(jsonText) as Map<String, dynamic>;
    return parse(data);
  }

  PortfolioSeed parse(Map<String, dynamic> data) {
    final firmProfile = data['firm_profile'] as Map<String, dynamic>;
    final profileDoc = firmProfile['default'] as Map<String, dynamic>;

    return PortfolioSeed(
      firmProfile: FirmProfile.fromJson(profileDoc),
      practiceAreas: _list(data['practice_areas'], PracticeArea.fromJson),
      attorneys: _list(data['attorneys'], Attorney.fromJson),
      representativeMatters: _list(
        data['representative_matters'],
        RepresentativeMatter.fromJson,
      ),
      testimonials: _list(data['testimonials'], ClientTestimonial.fromJson),
      resources: _list(data['resources'], LegalResource.fromJson),
      faqs: _list(data['faqs'], FaqItem.fromJson),
    );
  }

  List<T> _list<T>(
    Object? value,
    T Function(Map<String, dynamic> json, {String? id}) builder,
  ) {
    return (value as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((json) => builder(json))
        .toList();
  }
}
