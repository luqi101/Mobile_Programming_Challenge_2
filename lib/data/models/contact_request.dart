import 'package:cloud_firestore/cloud_firestore.dart';

class ContactRequest {
  const ContactRequest({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.practiceArea,
    required this.message,
    required this.consent,
  });

  final String fullName;
  final String email;
  final String phone;
  final String practiceArea;
  final String message;
  final bool consent;

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName.trim(),
      'email': email.trim().toLowerCase(),
      'phone': phone.trim(),
      'practiceArea': practiceArea.trim(),
      'message': message.trim(),
      'consent': consent,
      'status': 'new',
      'source': 'mobile_app',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
