import 'package:flutter/material.dart';

class PrimaryCtaButton extends StatelessWidget {
  const PrimaryCtaButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, overflow: TextOverflow.ellipsis),
    );
  }
}
