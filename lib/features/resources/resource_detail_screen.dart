import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/legal_resource.dart';
import '../../shared/widgets/content_card.dart';
import '../../shared/widgets/legal_disclaimer_card.dart';
import '../../shared/widgets/page_shell.dart';

class ResourceDetailScreen extends StatelessWidget {
  const ResourceDetailScreen({super.key, required this.resource});

  final LegalResource resource;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Legal Resource')),
      body: PageShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.category,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.blueGrey,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resource.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${resource.readTimeMinutes} minute read • ${resource.publishedDate}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppTheme.blueGrey),
                  ),
                  const SizedBox(height: 18),
                  Text(resource.body),
                ],
              ),
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
