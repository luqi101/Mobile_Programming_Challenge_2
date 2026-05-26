import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../shared/responsive/breakpoints.dart';
import '../../shared/widgets/firm_mark.dart';
import '../about/about_screen.dart';
import '../app_info/app_info_screen.dart';
import '../contact/contact_screen.dart';
import '../faq/faq_screen.dart';
import '../home/home_screen.dart';
import '../matters/matters_screen.dart';
import '../practice_areas/practice_areas_screen.dart';
import '../resources/resources_screen.dart';
import '../team/team_screen.dart';

class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({
    super.key,
    required this.repository,
    required this.firebaseReady,
    this.firebaseError,
  });

  final PortfolioRepository repository;
  final bool firebaseReady;
  final Object? firebaseError;

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  var _selectedIndex = 0;

  late final List<_ShellDestination> _destinations = [
    _ShellDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      builder: () => HomeScreen(
        repository: widget.repository,
        onServicesSelected: () => _select(1),
        onTeamSelected: () => _select(2),
        onResourcesSelected: () => _select(3),
        onContactSelected: () => _select(4),
        onAboutSelected: () =>
            _push(AboutScreen(repository: widget.repository)),
        onMattersSelected: () =>
            _push(MattersScreen(repository: widget.repository)),
      ),
    ),
    _ShellDestination(
      label: 'Services',
      icon: Icons.balance_outlined,
      selectedIcon: Icons.balance,
      builder: () => PracticeAreasScreen(repository: widget.repository),
    ),
    _ShellDestination(
      label: 'Team',
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups,
      builder: () => TeamScreen(repository: widget.repository),
    ),
    _ShellDestination(
      label: 'Resources',
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book,
      builder: () => ResourcesScreen(
        repository: widget.repository,
        onFaqSelected: () => _push(FaqScreen(repository: widget.repository)),
      ),
    ),
    _ShellDestination(
      label: 'Contact',
      icon: Icons.mail_outline,
      selectedIcon: Icons.mail,
      builder: () => ContactScreen(
        repository: widget.repository,
        firebaseReady: widget.firebaseReady,
      ),
    ),
  ];

  void _select(int index) {
    setState(() => _selectedIndex = index);
  }

  void _push(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final windowClass = Breakpoints.of(context);
    final isCompact = windowClass == WindowClass.compact;
    final body = _destinations[_selectedIndex].builder();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: 'App information',
            onPressed: () => _push(
              AppInfoScreen(
                repository: widget.repository,
                firebaseReady: widget.firebaseReady,
                firebaseError: widget.firebaseError,
              ),
            ),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (!isCompact)
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _select,
                labelType: NavigationRailLabelType.all,
                leading: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: FirmMark(size: 46, showText: false),
                ),
                destinations: [
                  for (final destination in _destinations)
                    NavigationRailDestination(
                      icon: Icon(destination.icon),
                      selectedIcon: Icon(destination.selectedIcon),
                      label: Text(destination.label),
                    ),
                ],
              ),
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: isCompact
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _select,
              destinations: [
                for (final destination in _destinations)
                  NavigationDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selectedIcon),
                    label: destination.label,
                  ),
              ],
            )
          : null,
      backgroundColor: AppTheme.ivory,
    );
  }
}

class _ShellDestination {
  const _ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget Function() builder;
}
