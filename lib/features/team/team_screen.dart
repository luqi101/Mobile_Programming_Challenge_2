import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/attorney.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../shared/responsive/responsive_grid.dart';
import '../../shared/widgets/async_state_view.dart';
import '../../shared/widgets/content_card.dart';
import '../../shared/widgets/page_shell.dart';
import '../../shared/widgets/section_header.dart';
import 'attorney_detail_screen.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key, required this.repository});

  final PortfolioRepository repository;

  @override
  Widget build(BuildContext context) {
    return AsyncStateView<List<Attorney>>(
      future: repository.getAttorneys(),
      emptyMessage: 'No attorney profiles are available in Firestore yet.',
      builder: (context, attorneys) => PageShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Attorneys',
              subtitle:
                  'Fictional lawyers with original bios and portfolio-safe credentials.',
            ),
            ResponsiveGrid(
              children: [
                for (final attorney in attorneys)
                  _AttorneyCard(
                    attorney: attorney,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            AttorneyDetailScreen(attorney: attorney),
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

class _AttorneyCard extends StatelessWidget {
  const _AttorneyCard({required this.attorney, required this.onTap});

  final Attorney attorney;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.navy,
            child: Text(
              attorney.initials,
              style: const TextStyle(
                color: AppTheme.gold,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(attorney.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            attorney.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.blueGrey,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(attorney.specialization),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip('${attorney.experienceYears} yrs'),
              _Chip(attorney.credentials),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.ivory,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
