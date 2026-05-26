import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/firm_mark.dart';
import '../shell/adaptive_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.repository,
    required this.firebaseReady,
    this.firebaseError,
  });

  final PortfolioRepository repository;
  final bool firebaseReady;
  final Object? firebaseError;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.firebaseReady) {
      Timer(const Duration(milliseconds: 900), _openApp);
    }
  }

  void _openApp() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AdaptiveShell(
          repository: widget.repository,
          firebaseReady: widget.firebaseReady,
          firebaseError: widget.firebaseError,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.firebaseReady) {
      return Scaffold(
        body: ErrorState(
          title: 'Firebase needs configuration',
          message:
              'The app can continue with local seed data for layout review, but final portfolio data and contact submissions require Cloud Firestore. Run firebase login, then flutterfire configure.',
          action: ElevatedButton.icon(
            onPressed: _openApp,
            icon: const Icon(Icons.visibility_outlined),
            label: const Text('Preview with local fallback'),
          ),
        ),
      );
    }

    return const Scaffold(
      backgroundColor: AppTheme.ivory,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FirmMark(size: 72),
                SizedBox(height: 28),
                Text(
                  AppConstants.tagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.charcoal,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 26),
                CircularProgressIndicator(color: AppTheme.gold),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
