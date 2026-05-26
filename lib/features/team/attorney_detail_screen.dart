import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/attorney.dart';
import '../../shared/widgets/content_card.dart';
import '../../shared/widgets/page_shell.dart';

class AttorneyDetailScreen extends StatelessWidget {
  const AttorneyDetailScreen({super.key, required this.attorney});

  final Attorney attorney;

  Future<void> _emailAttorney() async {
    final uri = Uri(
      scheme: 'mailto',
      path: attorney.email,
      query: 'subject=Consultation request for ${attorney.name}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(attorney.name)),
      body: PageShell(
        child: ContentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppTheme.navy,
                    child: Text(
                      attorney.initials,
                      style: const TextStyle(
                        color: AppTheme.gold,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attorney.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          attorney.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(attorney.specialization),
              const SizedBox(height: 18),
              Text(attorney.bio),
              const SizedBox(height: 18),
              _DetailRow(label: 'Credentials', value: attorney.credentials),
              _DetailRow(label: 'Education', value: attorney.education),
              _DetailRow(
                label: 'Experience',
                value: '${attorney.experienceYears} years',
              ),
              _DetailRow(label: 'Email', value: attorney.email),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: _emailAttorney,
                icon: const Icon(Icons.mail_outline),
                label: const Text('Open email app'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

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
            width: 110,
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
