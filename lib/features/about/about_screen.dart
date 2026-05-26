import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../shared/widgets/async_state_view.dart';
import '../../shared/widgets/content_card.dart';
import '../../shared/widgets/legal_disclaimer_card.dart';
import '../../shared/widgets/page_shell.dart';
import '../../shared/widgets/section_header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.repository});

  final PortfolioRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About the Firm')),
      body: AsyncStateView(
        future: repository.getFirmProfile(),
        builder: (context, profile) => PageShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: profile.name, subtitle: profile.tagline),
              ContentCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.overview,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Mission',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(profile.mission),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _BulletSection(title: 'Values', items: profile.values),
              const SizedBox(height: 18),
              _BulletSection(
                title: 'Why Choose Us',
                items: profile.whyChooseUs,
              ),
              const SizedBox(height: 18),
              LegalDisclaimerCard(
                text: '${profile.disclaimer} ${AppConstants.contactDisclaimer}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
