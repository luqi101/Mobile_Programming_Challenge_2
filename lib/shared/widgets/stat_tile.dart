import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'content_card.dart';

class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.blueGrey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
