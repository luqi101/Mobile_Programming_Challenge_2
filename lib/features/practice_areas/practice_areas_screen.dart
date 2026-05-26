import 'package:flutter/material.dart';

import '../../core/utils/icon_mapper.dart';
import '../../data/models/practice_area.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../shared/responsive/responsive_grid.dart';
import '../../shared/widgets/async_state_view.dart';
import '../../shared/widgets/content_card.dart';
import '../../shared/widgets/page_shell.dart';
import '../../shared/widgets/section_header.dart';
import 'practice_area_detail_screen.dart';

class PracticeAreasScreen extends StatelessWidget {
  const PracticeAreasScreen({super.key, required this.repository});

  final PortfolioRepository repository;

  @override
  Widget build(BuildContext context) {
    return AsyncStateView<List<PracticeArea>>(
      future: repository.getPracticeAreas(),
      emptyMessage: 'No practice areas are available in Firestore yet.',
      builder: (context, areas) => PageShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Practice Areas',
              subtitle:
                  'Firestore-backed services presented with clear scope and careful language.',
            ),
            ResponsiveGrid(
              children: [
                for (final area in areas)
                  _PracticeAreaCard(
                    area: area,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PracticeAreaDetailScreen(area: area),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeAreaCard extends StatelessWidget {
  const _PracticeAreaCard({required this.area, required this.onTap});

  final PracticeArea area;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(IconMapper.fromKey(area.iconKey), size: 32),
          const SizedBox(height: 14),
          Text(area.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(area.shortSummary),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('View details'),
          ),
        ],
      ),
    );
  }
}
