import 'package:flutter/widgets.dart';

enum WindowClass { compact, medium, expanded }

class Breakpoints {
  const Breakpoints._();

  static const compactMax = 599.0;
  static const mediumMax = 899.0;
  static const maxContentWidth = 1180.0;

  static WindowClass of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= compactMax) return WindowClass.compact;
    if (width <= mediumMax) return WindowClass.medium;
    return WindowClass.expanded;
  }

  static int columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 900) return 2;
    return 3;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 600) {
      return const EdgeInsets.fromLTRB(16, 16, 16, 28);
    }
    return const EdgeInsets.fromLTRB(24, 24, 24, 36);
  }
}
