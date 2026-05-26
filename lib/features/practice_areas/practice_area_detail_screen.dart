import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/icon_mapper.dart';
import '../../data/models/practice_area.dart';
import '../../shared/widgets/content_card.dart';
import '../../shared/widgets/legal_disclaimer_card.dart';
import '../../shared/widgets/page_shell.dart';

class PracticeAreaDetailScreen extends StatelessWidget {
  const PracticeAreaDetailScreen({super.key, required this.area});

  final PracticeArea area;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(area.title)),
      body: PageShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(IconMapper.fromKey(area.iconKey), size: 42),
                  const SizedBox(height: 16),
                  Text(
                    area.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    area.shortSummary,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(area.description),
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
