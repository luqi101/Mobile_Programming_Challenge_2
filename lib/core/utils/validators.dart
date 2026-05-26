class Validators {
  const Validators._();

  static final _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static String? requiredText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? fullName(String? value) {
    final required = requiredText(value, 'Full name');
    if (required != null) return required;
    if (value!.trim().length < 2) {
      return 'Enter a full name with at least 2 characters.';
    }
    return null;
  }

  static String? email(String? value) {
    final required = requiredText(value, 'Email');
    if (required != null) return required;
    if (!_emailRegex.hasMatch(value!.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? optionalPhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 7) {
      return 'Enter a valid phone number or leave it blank.';
    }
    return null;
  }

  static String? message(String? value) {
    final required = requiredText(value, 'Message');
    if (required != null) return required;
    if (value!.trim().length < 20) {
      return 'Please include at least 20 characters so the request is clear.';
    }
    return null;
  }
}
