import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class FirmMark extends StatelessWidget {
  const FirmMark({super.key, this.size = 52, this.showText = true});

  final double size;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.navy,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.gold, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        'AP',
        style: TextStyle(
          color: AppTheme.gold,
          fontSize: size * 0.34,
          fontWeight: FontWeight.w900,
        ),
      ),
    );

    if (!showText) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aadil & Partners',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Legal',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.blueGrey,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
