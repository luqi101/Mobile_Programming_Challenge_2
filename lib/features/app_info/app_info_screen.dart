import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../data/services/seed_loader.dart';
import '../../shared/widgets/content_card.dart';
import '../../shared/widgets/legal_disclaimer_card.dart';
import '../../shared/widgets/page_shell.dart';
import '../../shared/widgets/section_header.dart';

class AppInfoScreen extends StatefulWidget {
  const AppInfoScreen({
    super.key,
    required this.repository,
    required this.firebaseReady,
    this.firebaseError,
  });

  final PortfolioRepository repository;
  final bool firebaseReady;
  final Object? firebaseError;

  @override
  State<AppInfoScreen> createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends State<AppInfoScreen> {
  var _seeding = false;

  Future<void> _seedFirestore() async {
    setState(() => _seeding = true);
    try {
      final seed = await const SeedLoader().load();
      await widget.repository.seedPortfolioData(seed);
      _showSnack('Seed data import completed.');
    } catch (error) {
      _showSnack('Seed import failed: $error');
    } finally {
      if (mounted) setState(() => _seeding = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Info')),
      body: PageShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Submission App',
              subtitle:
                  'Course context, Firebase status, and originality notes.',
            ),
            ContentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(label: 'Course', value: AppConstants.course),
                  _InfoRow(label: 'Challenge', value: AppConstants.challenge),
                  _InfoRow(label: 'Topic', value: AppConstants.group),
                  _InfoRow(label: 'App', value: AppConstants.appName),
                  _InfoRow(label: 'Version', value: AppConstants.version),
                  _InfoRow(
                    label: 'Data source',
                    value: widget.repository.sourceLabel,
                  ),
                  _InfoRow(
                    label: 'Firebase',
                    value: widget.firebaseReady
                        ? 'Initialized'
                        : 'Not configured in this environment',
                  ),
                  if (widget.firebaseError != null)
                    _InfoRow(
                      label: 'Firebase error',
                      value: widget.firebaseError.toString(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ContentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Originality Statement',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'All firm names, attorney profiles, testimonials, resources, and representative matters are fictional and written for this course project. The app does not use real law firm branding or copied lawyer biographies.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (kDebugMode)
              ContentCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug Firestore Seed Utility',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This hidden debug-only action imports assets/data/portfolio_seed.json into Firestore. It requires Firebase configuration and development write rules or authenticated admin setup.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: widget.firebaseReady && !_seeding
                          ? _seedFirestore
                          : null,
                      icon: _seeding
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.cloud_upload_outlined),
                      label: Text(
                        _seeding ? 'Importing...' : 'Import seed data',
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 18),
            const LegalDisclaimerCard(
              text:
                  '${AppConstants.noLegalAdviceDisclaimer} ${AppConstants.contactDisclaimer}',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.blueGrey,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
