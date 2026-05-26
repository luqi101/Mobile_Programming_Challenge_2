import 'package:aadil_partners_legal/data/models/attorney.dart';
import 'package:aadil_partners_legal/data/models/practice_area.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Model parsing', () {
    test('parses practice area JSON safely', () {
      final area = PracticeArea.fromJson({
        'title': 'Corporate & Business Law',
        'shortSummary': 'Contracts and governance',
        'description': 'Detailed description',
        'iconKey': 'business',
        'priority': 1,
        'featured': true,
      }, id: 'corporate-business');

      expect(area.id, 'corporate-business');
      expect(area.featured, isTrue);
      expect(area.priority, 1);
    });

    test('parses attorney JSON safely', () {
      final attorney = Attorney.fromJson({
        'name': 'Samira Aadil',
        'title': 'Managing Partner',
        'specialization': 'Corporate governance',
        'bio': 'Original fictional bio',
        'credentials': 'J.D.',
        'education': 'Fictional law school',
        'experienceYears': 14,
        'email': 'samira@example.com',
        'initials': 'SA',
        'priority': 1,
        'practiceAreaIds': ['corporate-business'],
      }, id: 'samira-aadil');

      expect(attorney.id, 'samira-aadil');
      expect(attorney.practiceAreaIds, contains('corporate-business'));
      expect(attorney.experienceYears, 14);
    });
  });
}
