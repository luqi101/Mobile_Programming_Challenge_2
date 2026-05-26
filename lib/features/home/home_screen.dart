import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/icon_mapper.dart';
import '../../data/models/attorney.dart';
import '../../data/models/firm_profile.dart';
import '../../data/models/practice_area.dart';
import '../../data/models/testimonial.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../shared/responsive/responsive_grid.dart';
import '../../shared/widgets/async_state_view.dart';
import '../../shared/widgets/content_card.dart';
import '../../shared/widgets/firm_mark.dart';
import '../../shared/widgets/legal_disclaimer_card.dart';
import '../../shared/widgets/page_shell.dart';
import '../../shared/widgets/primary_cta_button.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/stat_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.repository,
    required this.onServicesSelected,
    required this.onTeamSelected,
    required this.onResourcesSelected,
    required this.onContactSelected,
    required this.onAboutSelected,
    required this.onMattersSelected,
  });

  final PortfolioRepository repository;
  final VoidCallback onServicesSelected;
  final VoidCallback onTeamSelected;
  final VoidCallback onResourcesSelected;
  final VoidCallback onContactSelected;
  final VoidCallback onAboutSelected;
  final VoidCallback onMattersSelected;

  @override
  Widget build(BuildContext context) {
    return AsyncStateView<FirmProfile>(
      future: repository.getFirmProfile(),
      builder: (context, profile) => PageShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroPanel(
              profile: profile,
              sourceLabel: repository.sourceLabel,
              onServicesSelected: onServicesSelected,
              onContactSelected: onContactSelected,
            ),
            const SizedBox(height: 22),
            ResponsiveGrid(
              minItemWidth: 180,
              children: [
                for (final stat in profile.stats)
                  StatTile(value: stat.value, label: stat.label),
              ],
            ),
            const SizedBox(height: 28),
            _FeaturedPracticeAreas(
              repository: repository,
              onServicesSelected: onServicesSelected,
            ),
            const SizedBox(height: 28),
            _TeamPreview(
              repository: repository,
              onTeamSelected: onTeamSelected,
            ),
            const SizedBox(height: 28),
            _TestimonialsPreview(repository: repository),
            const SizedBox(height: 28),
            _ActionStrip(
              onAboutSelected: onAboutSelected,
              onMattersSelected: onMattersSelected,
              onResourcesSelected: onResourcesSelected,
              onContactSelected: onContactSelected,
            ),
            const SizedBox(height: 18),
            LegalDisclaimerCard(text: profile.disclaimer),
          ],
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.profile,
    required this.sourceLabel,
    required this.onServicesSelected,
    required this.onContactSelected,
  });

  final FirmProfile profile;
  final String sourceLabel;
  final VoidCallback onServicesSelected;
  final VoidCallback onContactSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.navy,
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          final intro = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FirmMark(size: 58, showText: false),
              const SizedBox(height: 22),
              Text(
                profile.name,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontSize: wide ? 40 : 32,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                profile.tagline,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: AppTheme.gold),
              ),
              const SizedBox(height: 16),
              Text(
                profile.overview,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.88),
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  PrimaryCtaButton(
                    label: 'Request Consultation',
                    icon: Icons.calendar_month_outlined,
                    onPressed: onContactSelected,
                  ),
                  OutlinedButton.icon(
                    onPressed: onServicesSelected,
                    icon: const Icon(Icons.balance_outlined),
                    label: const Text('Explore Services'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          );

          final contact = ContentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portfolio Data',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('Source: $sourceLabel'),
                const SizedBox(height: 14),
                _ContactLine(icon: Icons.phone_outlined, text: profile.phone),
                _ContactLine(icon: Icons.mail_outline, text: profile.email),
                _ContactLine(
                  icon: Icons.location_on_outlined,
                  text: profile.address,
                ),
              ],
            ),
          );

          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [intro, const SizedBox(height: 18), contact],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: intro),
              const SizedBox(width: 24),
              Expanded(flex: 2, child: contact),
            ],
          );
        },
      ),
    );
  }
}

class _FeaturedPracticeAreas extends StatelessWidget {
  const _FeaturedPracticeAreas({
    required this.repository,
    required this.onServicesSelected,
  });

  final PortfolioRepository repository;
  final VoidCallback onServicesSelected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PracticeArea>>(
      future: repository.getPracticeAreas(),
      builder: (context, snapshot) {
        final areas = (snapshot.data ?? [])
            .where((area) => area.featured)
            .take(3);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Featured Services',
              subtitle: 'Selected practice areas loaded from portfolio data.',
              action: TextButton(
                onPressed: onServicesSelected,
                child: const Text('All services'),
              ),
            ),
            ResponsiveGrid(
              children: [
                for (final area in areas)
                  ContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(IconMapper.fromKey(area.iconKey), size: 30),
                        const SizedBox(height: 12),
                        Text(
                          area.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(area.shortSummary),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _TeamPreview extends StatelessWidget {
  const _TeamPreview({required this.repository, required this.onTeamSelected});

  final PortfolioRepository repository;
  final VoidCallback onTeamSelected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Attorney>>(
      future: repository.getAttorneys(),
      builder: (context, snapshot) {
        final attorneys = (snapshot.data ?? []).take(2);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Team Preview',
              subtitle: 'Fictional profiles with original portfolio content.',
              action: TextButton(
                onPressed: onTeamSelected,
                child: const Text('Meet the team'),
              ),
            ),
            ResponsiveGrid(
              children: [
                for (final attorney in attorneys)
                  ContentCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.navy,
                          child: Text(
                            attorney.initials,
                            style: const TextStyle(
                              color: AppTheme.gold,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                attorney.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(attorney.specialization),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _TestimonialsPreview extends StatelessWidget {
  const _TestimonialsPreview({required this.repository});

  final PortfolioRepository repository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClientTestimonial>>(
      future: repository.getTestimonials(),
      builder: (context, snapshot) {
        final testimonials = (snapshot.data ?? []).take(2);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Client Perspective',
              subtitle: 'Original fictional testimonials using initials only.',
            ),
            ResponsiveGrid(
              children: [
                for (final testimonial in testimonials)
                  ContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              testimonial.clientInitials,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            Icon(Icons.star, color: AppTheme.gold, size: 20),
                            Text('${testimonial.rating}/5'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('"${testimonial.quote}"'),
                        const SizedBox(height: 8),
                        Text(
                          testimonial.serviceArea,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.blueGrey,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ActionStrip extends StatelessWidget {
  const _ActionStrip({
    required this.onAboutSelected,
    required this.onMattersSelected,
    required this.onResourcesSelected,
    required this.onContactSelected,
  });

  final VoidCallback onAboutSelected;
  final VoidCallback onMattersSelected;
  final VoidCallback onResourcesSelected;
  final VoidCallback onContactSelected;

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          OutlinedButton.icon(
            onPressed: onAboutSelected,
            icon: const Icon(Icons.apartment_outlined),
            label: const Text('About'),
          ),
          OutlinedButton.icon(
            onPressed: onMattersSelected,
            icon: const Icon(Icons.description_outlined),
            label: const Text('Representative Matters'),
          ),
          OutlinedButton.icon(
            onPressed: onResourcesSelected,
            icon: const Icon(Icons.menu_book_outlined),
            label: const Text('Resources'),
          ),
          ElevatedButton.icon(
            onPressed: onContactSelected,
            icon: const Icon(Icons.mail_outline),
            label: const Text('Consultation Form'),
          ),
        ],
      ),
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.blueGrey),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
