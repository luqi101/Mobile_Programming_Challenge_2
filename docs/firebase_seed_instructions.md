# Firestore Seed Instructions

This app uses Cloud Firestore as the primary portfolio data source. The seed data lives in `assets/data/portfolio_seed.json` so the portfolio content can be recreated consistently.

## Required Collections

- `firm_profile/default`
- `practice_areas`
- `attorneys`
- `representative_matters`
- `testimonials`
- `resources`
- `faqs`
- `contact_requests`

## Recommended Student Workflow

1. Run `firebase login`.
2. Run `flutterfire configure --platforms=android,web --android-package-name=com.aadilpartners.legalportfolio --out=lib/firebase_options.dart`.
3. Create the Firestore database in Firebase Console if it does not exist.
4. Import the portfolio seed content from `assets/data/portfolio_seed.json`.
5. Deploy final read/contact rules with `firebase deploy --only firestore:rules,firestore:indexes`.

The FlutterFire command generates `lib/firebase_options.dart` and `android/app/google-services.json`. Those files are required for local execution but are intentionally ignored by Git because they contain project-specific Firebase client API keys. Safe examples are committed as `lib/firebase_options.example.dart` and `android/app/google-services.example.json`.

## Debug Import Utility

The app includes a debug-only seed button on the App Info screen. It is hidden from release builds through Flutter's `kDebugMode`.

For the debug import button to write portfolio collections, use it only during setup before deploying the final locked rules, or temporarily allow writes during development from Firebase Console. After seeding, restore and deploy the final `firestore.rules` file.

Do not commit service account JSON files, private keys, or any Firebase Admin credentials.
Do not commit the real generated Firebase client config files unless the course instructor explicitly requires them in a private submission package.
