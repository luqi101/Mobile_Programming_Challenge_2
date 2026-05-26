import 'package:aadil_partners_legal/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('accepts valid contact fields', () {
      expect(Validators.fullName('Sam Client'), isNull);
      expect(Validators.email('client@example.com'), isNull);
      expect(Validators.optionalPhone('+1 807 555 0147'), isNull);
      expect(
        Validators.message('I would like help reviewing a business contract.'),
        isNull,
      );
    });

    test('rejects invalid contact fields', () {
      expect(Validators.fullName(''), isNotNull);
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.optionalPhone('12'), isNotNull);
      expect(Validators.message('Too short'), isNotNull);
    });
  });
}
