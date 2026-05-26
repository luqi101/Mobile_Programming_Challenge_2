import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/legal_resource.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../shared/responsive/responsive_grid.dart';
import '../../shared/widgets/async_state_view.dart';
import '../../shared/widgets/content_card.dart';
import '../../shared/widgets/legal_disclaimer_card.dart';
import '../../shared/widgets/page_shell.dart';
import '../../shared/widgets/section_header.dart';
import 'resource_detail_screen.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({
    super.key,
    required this.repository,
    required this.onFaqSelected,
  });

  final PortfolioRepository repository;
  final VoidCallback onFaqSelected;

  @override
  Widget build(BuildContext context) {
    return AsyncStateView<List<LegalResource>>(
      future: repository.getResources(),
      emptyMessage: 'No resources are available in Firestore yet.',
      builder: (context, resources) => PageShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Resources',
              subtitle:
                  'Short original insights written for this student portfolio.',
              action: OutlinedButton.icon(
                onPressed: onFaqSelected,
                icon: const Icon(Icons.help_outline),
                label: const Text('FAQ'),
              ),
            ),
            ResponsiveGrid(
              children: [
                for (final resource in resources)
                  _ResourceCard(
                    resource: resource,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ResourceDetailScreen(resource: resource),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const LegalDisclaimerCard(
              text: AppConstants.noLegalAdviceDisclaimer,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({required this.resource, required this.onTap});

  final LegalResource resource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.article_outlined),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${resource.category} • ${resource.readTimeMinutes} min',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.blueGrey,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(resource.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(resource.summary),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Read insight'),
          ),
        ],
      ),
    );
  }
}
