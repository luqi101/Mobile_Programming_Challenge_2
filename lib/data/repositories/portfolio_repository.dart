import '../models/attorney.dart';
import '../models/contact_request.dart';
import '../models/faq_item.dart';
import '../models/firm_profile.dart';
import '../models/legal_resource.dart';
import '../models/practice_area.dart';
import '../models/representative_matter.dart';
import '../models/testimonial.dart';
import '../services/seed_loader.dart';

abstract class PortfolioRepository {
  String get sourceLabel;

  Future<FirmProfile> getFirmProfile();

  Future<List<PracticeArea>> getPracticeAreas();

  Future<List<Attorney>> getAttorneys();

  Future<List<RepresentativeMatter>> getRepresentativeMatters();

  Future<List<ClientTestimonial>> getTestimonials();

  Future<List<LegalResource>> getResources();

  Future<List<FaqItem>> getFaqs();

  Future<void> submitContactRequest(ContactRequest request);

  Future<void> seedPortfolioData(PortfolioSeed seed);
}
