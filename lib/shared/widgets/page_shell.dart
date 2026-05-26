import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';

class PageShell extends StatelessWidget {
  const PageShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: Breakpoints.pagePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.maxContentWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}
