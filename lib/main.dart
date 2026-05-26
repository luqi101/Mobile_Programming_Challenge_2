import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'data/repositories/asset_fallback_portfolio_repository.dart';
import 'data/repositories/firestore_portfolio_repository.dart';
import 'data/repositories/portfolio_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final fallbackRepository = AssetFallbackPortfolioRepository();
  PortfolioRepository repository = fallbackRepository;
  var firebaseReady = false;
  Object? firebaseError;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    repository = FirestorePortfolioRepository(
      FirebaseFirestore.instance,
      fallback: fallbackRepository,
    );
    firebaseReady = true;
  } catch (error) {
    firebaseError = error;
  }

  runApp(
    AadilLegalApp(
      repository: repository,
      firebaseReady: firebaseReady,
      firebaseError: firebaseError,
    ),
  );
}
