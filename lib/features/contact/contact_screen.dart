import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../data/models/contact_request.dart';
import '../../data/models/practice_area.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../shared/widgets/async_state_view.dart';
import '../../shared/widgets/content_card.dart';
import '../../shared/widgets/legal_disclaimer_card.dart';
import '../../shared/widgets/page_shell.dart';
import '../../shared/widgets/section_header.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({
    super.key,
    required this.repository,
    required this.firebaseReady,
  });

  final PortfolioRepository repository;
  final bool firebaseReady;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  var _consent = false;
  var _submitting = false;
  String? _practiceArea;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    if (!_consent) {
      _showSnack('Please acknowledge the consultation disclaimer.');
      return;
    }
    if (!widget.firebaseReady) {
      _showSnack(
        'Firestore must be configured before contact requests can be submitted.',
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await widget.repository.submitContactRequest(
        ContactRequest(
          fullName: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          practiceArea: _practiceArea ?? 'General consultation',
          message: _messageController.text,
          consent: _consent,
        ),
      );
      _formKey.currentState?.reset();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
      setState(() {
        _practiceArea = null;
        _consent = false;
      });
      _showSnack('Consultation request submitted to Firestore.');
    } catch (error) {
      _showSnack('Submission failed: $error');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AsyncStateView<List<PracticeArea>>(
      future: widget.repository.getPracticeAreas(),
      builder: (context, areas) => PageShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Request a Consultation',
              subtitle:
                  'Validated intake form. Successful submissions are written to Firestore.',
            ),
            if (!widget.firebaseReady) ...[
              const LegalDisclaimerCard(
                text:
                    'Firebase is not configured in this environment. The form is visible for review, but Firestore submission is disabled until FlutterFire configuration is completed.',
              ),
              const SizedBox(height: 16),
            ],
            ContentCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: Validators.fullName,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone optional',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: Validators.optionalPhone,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _practiceArea,
                      decoration: const InputDecoration(
                        labelText: 'Preferred practice area',
                        prefixIcon: Icon(Icons.balance_outlined),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: 'General consultation',
                          child: Text('General consultation'),
                        ),
                        for (final area in areas)
                          DropdownMenuItem(
                            value: area.title,
                            child: Text(area.title),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => _practiceArea = value),
                      validator: (value) => Validators.requiredText(
                        value,
                        'Preferred practice area',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.notes_outlined),
                      ),
                      minLines: 4,
                      maxLines: 8,
                      validator: Validators.message,
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _consent,
                      onChanged: (value) {
                        setState(() => _consent = value ?? false);
                      },
                      title: const Text(AppConstants.contactDisclaimer),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitting ? null : _submit,
                        icon: _submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send_outlined),
                        label: Text(
                          _submitting ? 'Submitting...' : 'Submit request',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const LegalDisclaimerCard(
              text:
                  '${AppConstants.noLegalAdviceDisclaimer} ${AppConstants.contactDisclaimer}',
            ),
            const SizedBox(height: 18),
            ContentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Submission Storage',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Valid requests are created in the Firestore collection contact_requests with source mobile_app, status new, and a server timestamp.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppTheme.blueGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
