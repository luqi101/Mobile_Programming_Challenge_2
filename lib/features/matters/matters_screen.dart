import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/representative_matter.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../shared/responsive/responsive_grid.dart';
import '../../shared/widgets/async_state_view.dart';
import '../../shared/widgets/content_card.dart';
import '../../shared/widgets/legal_disclaimer_card.dart';
import '../../shared/widgets/page_shell.dart';
import '../../shared/widgets/section_header.dart';

class MattersScreen extends StatelessWidget {
  const MattersScreen({super.key, required this.repository});

  final PortfolioRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Representative Matters')),
      body: AsyncStateView<List<RepresentativeMatter>>(
        future: repository.getRepresentativeMatters(),
        emptyMessage:
            'No representative matters are available in Firestore yet.',
        builder: (context, matters) => PageShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Representative Matters',
                subtitle:
                    'Anonymized fictional examples that avoid outcome promises.',
              ),
              ResponsiveGrid(
                children: [
                  for (final matter in matters)
                    ContentCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.description_outlined, size: 30),
                          const SizedBox(height: 12),
                          Text(
                            matter.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(matter.summary),
                          const SizedBox(height: 12),
                          Text(
                            matter.disclaimer,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              const LegalDisclaimerCard(text: AppConstants.mattersDisclaimer),
            ],
          ),
        ),
      ),
    );
  }
}
