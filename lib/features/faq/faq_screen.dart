import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/faq_item.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../shared/widgets/async_state_view.dart';
import '../../shared/widgets/legal_disclaimer_card.dart';
import '../../shared/widgets/page_shell.dart';
import '../../shared/widgets/section_header.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key, required this.repository});

  final PortfolioRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: AsyncStateView<List<FaqItem>>(
        future: repository.getFaqs(),
        emptyMessage: 'No FAQ entries are available in Firestore yet.',
        builder: (context, faqs) => PageShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Frequently Asked Questions',
                subtitle:
                    'Practical intake questions for a fictional law firm portfolio.',
              ),
              for (final faq in faqs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ExpansionTile(
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(
                      faq.question,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(faq.category),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(faq.answer),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              const LegalDisclaimerCard(
                text: AppConstants.noLegalAdviceDisclaimer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
