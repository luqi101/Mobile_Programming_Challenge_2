import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/attorney.dart';
import '../models/contact_request.dart';
import '../models/faq_item.dart';
import '../models/firm_profile.dart';
import '../models/legal_resource.dart';
import '../models/practice_area.dart';
import '../models/representative_matter.dart';
import '../models/testimonial.dart';
import '../services/seed_loader.dart';
import 'portfolio_repository.dart';

class FirestorePortfolioRepository implements PortfolioRepository {
  FirestorePortfolioRepository(this._firestore, {this.fallback});

  final FirebaseFirestore _firestore;
  final PortfolioRepository? fallback;

  @override
  String get sourceLabel => 'Cloud Firestore';

  @override
  Future<FirmProfile> getFirmProfile() {
    return _withFallback(() async {
      final doc = await _firestore
          .collection('firm_profile')
          .doc('default')
          .get();
      if (!doc.exists || doc.data() == null) {
        throw StateError('Missing firm_profile/default in Firestore.');
      }
      return FirmProfile.fromJson(doc.data()!);
    }, () => fallback?.getFirmProfile());
  }

  @override
  Future<List<PracticeArea>> getPracticeAreas() {
    return _collection(
      'practice_areas',
      (json, id) => PracticeArea.fromJson(json, id: id),
      () => fallback?.getPracticeAreas(),
    );
  }

  @override
  Future<List<Attorney>> getAttorneys() {
    return _collection(
      'attorneys',
      (json, id) => Attorney.fromJson(json, id: id),
      () => fallback?.getAttorneys(),
    );
  }

  @override
  Future<List<RepresentativeMatter>> getRepresentativeMatters() {
    return _collection(
      'representative_matters',
      (json, id) => RepresentativeMatter.fromJson(json, id: id),
      () => fallback?.getRepresentativeMatters(),
    );
  }

  @override
  Future<List<ClientTestimonial>> getTestimonials() {
    return _collection(
      'testimonials',
      (json, id) => ClientTestimonial.fromJson(json, id: id),
      () => fallback?.getTestimonials(),
    );
  }

  @override
  Future<List<LegalResource>> getResources() {
    return _collection(
      'resources',
      (json, id) => LegalResource.fromJson(json, id: id),
      () => fallback?.getResources(),
    );
  }

  @override
  Future<List<FaqItem>> getFaqs() {
    return _collection(
      'faqs',
      (json, id) => FaqItem.fromJson(json, id: id),
      () => fallback?.getFaqs(),
    );
  }

  @override
  Future<void> submitContactRequest(ContactRequest request) {
    return _firestore.collection('contact_requests').add(request.toFirestore());
  }

  @override
  Future<void> seedPortfolioData(PortfolioSeed seed) async {
    final batch = _firestore.batch();
    batch.set(
      _firestore.collection('firm_profile').doc('default'),
      seed.firmProfile.toJson(),
    );

    for (final area in seed.practiceAreas) {
      batch.set(
        _firestore.collection('practice_areas').doc(area.id),
        area.toJson(),
      );
    }
    for (final attorney in seed.attorneys) {
      batch.set(
        _firestore.collection('attorneys').doc(attorney.id),
        attorney.toJson(),
      );
    }
    for (final matter in seed.representativeMatters) {
      batch.set(
        _firestore.collection('representative_matters').doc(matter.id),
        matter.toJson(),
      );
    }
    for (final testimonial in seed.testimonials) {
      batch.set(
        _firestore.collection('testimonials').doc(testimonial.id),
        testimonial.toJson(),
      );
    }
    for (final resource in seed.resources) {
      batch.set(
        _firestore.collection('resources').doc(resource.id),
        resource.toJson(),
      );
    }
    for (final faq in seed.faqs) {
      batch.set(_firestore.collection('faqs').doc(faq.id), faq.toJson());
    }

    await batch.commit();
  }

  Future<List<T>> _collection<T>(
    String collection,
    T Function(Map<String, dynamic> json, String id) builder,
    Future<List<T>>? Function() fallback,
  ) {
    return _withFallback(() async {
      final snapshot = await _firestore
          .collection(collection)
          .orderBy('priority')
          .get(const GetOptions(source: Source.serverAndCache));
      return snapshot.docs
          .map((doc) => builder(doc.data(), doc.id))
          .toList(growable: false);
    }, fallback);
  }

  Future<T> _withFallback<T>(
    Future<T> Function() primary,
    Future<T>? Function() fallback,
  ) async {
    try {
      return await primary();
    } catch (_) {
      final fallbackFuture = fallback();
      if (fallbackFuture != null) {
        return fallbackFuture;
      }
      rethrow;
    }
  }
}
