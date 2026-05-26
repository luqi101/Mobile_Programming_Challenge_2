# AGENTS.md

## Project Purpose

This repository is for **CS5450 Mobile Programming — Challenge 2: Flutter Mobile Portfolio**.

The assigned group topic is:

> **Group #1: Law Firm Portfolio**

The final deliverable must be a professional Flutter/Dart mobile portfolio app for a fictional law firm. The app must demonstrate strong programming quality, functional completeness, Firebase-backed portfolio data, polished design, and responsive behavior.

The target grade is full marks. Treat technical correctness, stability, and submission completeness as non-negotiable.

---

## Assignment Requirements

The app must satisfy the following requirements:

1. Build a portfolio app using **Flutter/Dart**.
2. The portfolio must represent a law firm service/specialty.
3. The app must showcase the firm’s value, professionalism, services, and strengths.
4. Use **Firebase** to store portfolio data.
5. Include a professional **README.pdf** explaining:
   - configuration steps,
   - how to run the app,
   - screenshots,
   - exact project structure,
   - GitHub repository link.
6. Upload the full Android Studio / Flutter challenge project to a public GitHub repository.
7. Final ZIP package must include:
   - Dart files,
   - images/assets,
   - README.pdf.
8. App must be demonstrable through Android/iOS emulator and/or Chrome.
9. Avoid a web-only solution.
10. Prefer successful Android emulator execution.
11. Do not use copied work from other students or the web.

---

## Grading Priorities

The grading categories are:

| Category | Points |
|---|---:|
| Programming: Flutter/Dart | 10 |
| Functionality demonstrated by emulator/Chrome | 10 |
| App Design, Arts, Responsive Design | 10 |
| Total | 30 |

Known penalties:

| Issue | Penalty |
|---|---:|
| Minor technical flaw(s) | -3 |
| App does not work or is not presented | -15 |
| Partially missing resources | -3 |
| Late submission | -3/day |
| Works only on Chrome/web | -2 |
| Copied work | -30 |

Known bonus:

| Bonus | Points |
|---|---:|
| Works on actual phone device | +2 |

Therefore, all agents must prioritize:
- successful Android build,
- Firebase-backed data,
- zero broken imports,
- zero missing assets,
- responsive UI,
- professional README.pdf,
- complete ZIP contents,
- original work.

---

## Non-Negotiable Rules for Agents

1. **Do not delete user files without explicit approval.**
2. **Before any major restructuring, inspect the workspace first.**
3. **If the workspace is not a Flutter project, create a backup before converting.**
4. **Never assume Firebase is already configured. Verify it.**
5. **Do not hard-code all portfolio data inside widgets. Portfolio data must be stored/read through Firebase Firestore.**
6. **Do not create a Chrome-only solution. Android emulator support is required.**
7. **Do not use copyrighted law firm branding, real lawyer biographies, copied firm text, or unlicensed images.**
8. **Do not leave TODO comments in final submission files.**
9. **Do not introduce unnecessary dependencies.**
10. **Do not use unstable or obscure packages unless absolutely necessary.**
11. **Do not break null safety.**
12. **Do not ignore `flutter analyze`.**
13. **Do not produce a final app that requires undocumented manual steps to run.**
14. **Do not include secrets, private keys, service account files, or sensitive credentials in the repository.**

---

## Required Initial Audit

Before implementing, inspect and report:

- Current working directory.
- Whether `pubspec.yaml` exists.
- Whether `lib/main.dart` exists.
- Whether Flutter platform folders exist:
  - `android/`
  - `ios/`
  - `web/`
  - `macos/`
  - `windows/`
  - `linux/`
- Whether the project appears to be:
  - Flutter,
  - native Android/Kotlin,
  - native Android/Java,
  - empty/scaffolded incorrectly,
  - mixed or broken.
- Existing package name/application ID.
- Existing Firebase configuration files:
  - `lib/firebase_options.dart`
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
  - `firebase.json`
  - `firestore.rules`
- Existing screenshots/assets/docs that must be preserved.
- Current Git status, if repository is initialized.

Use safe read-only commands first, such as:

```bash
pwd
ls
find . -maxdepth 3 -type f | sort
git status --short