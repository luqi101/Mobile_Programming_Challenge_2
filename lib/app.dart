import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/portfolio_repository.dart';
import 'features/splash/splash_screen.dart';

class AadilLegalApp extends StatelessWidget {
  const AadilLegalApp({
    super.key,
    required this.repository,
    required this.firebaseReady,
    this.firebaseError,
  });

  final PortfolioRepository repository;
  final bool firebaseReady;
  final Object? firebaseError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: SplashScreen(
        repository: repository,
        firebaseReady: firebaseReady,
        firebaseError: firebaseError,
      ),
    );
  }
}
