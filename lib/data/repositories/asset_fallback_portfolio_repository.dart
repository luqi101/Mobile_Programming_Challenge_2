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

class AssetFallbackPortfolioRepository implements PortfolioRepository {
  AssetFallbackPortfolioRepository({this.seedLoader = const SeedLoader()});

  final SeedLoader seedLoader;
  PortfolioSeed? _cachedSeed;

  @override
  String get sourceLabel => 'Local seed fallback';

  Future<PortfolioSeed> _seed() async {
    return _cachedSeed ??= await seedLoader.load();
  }

  @override
  Future<List<Attorney>> getAttorneys() async => (await _seed()).attorneys;

  @override
  Future<List<FaqItem>> getFaqs() async => (await _seed()).faqs;

  @override
  Future<FirmProfile> getFirmProfile() async => (await _seed()).firmProfile;

  @override
  Future<List<PracticeArea>> getPracticeAreas() async {
    return (await _seed()).practiceAreas;
  }

  @override
  Future<List<RepresentativeMatter>> getRepresentativeMatters() async {
    return (await _seed()).representativeMatters;
  }

  @override
  Future<List<LegalResource>> getResources() async => (await _seed()).resources;

  @override
  Future<List<ClientTestimonial>> getTestimonials() async {
    return (await _seed()).testimonials;
  }

  @override
  Future<void> seedPortfolioData(PortfolioSeed seed) async {
    _cachedSeed = seed;
  }

  @override
  Future<void> submitContactRequest(ContactRequest request) {
    throw StateError(
      'Contact requests require Firebase Firestore configuration.',
    );
  }
}
