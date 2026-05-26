import 'package:flutter/material.dart';

import 'breakpoints.dart';

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.minItemWidth = 260,
  });

  final List<Widget> children;
  final double spacing;
  final double minItemWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final targetColumns = Breakpoints.columnsFor(constraints.maxWidth);
        final columns = targetColumns.clamp(1, children.length);
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        if (itemWidth < minItemWidth && columns > 1) {
          return _buildWrap(context, columns - 1, constraints.maxWidth);
        }
        return _buildWrap(context, columns, constraints.maxWidth);
      },
    );
  }

  Widget _buildWrap(BuildContext context, int columns, double maxWidth) {
    final width = (maxWidth - (spacing * (columns - 1))) / columns;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (final child in children)
          SizedBox(width: columns == 1 ? maxWidth : width, child: child),
      ],
    );
  }
}
