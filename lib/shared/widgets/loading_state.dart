import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message = 'Loading portfolio data...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppTheme.gold),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
