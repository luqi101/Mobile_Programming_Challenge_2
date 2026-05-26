import 'package:flutter/material.dart';

class IconMapper {
  const IconMapper._();

  static IconData fromKey(String key) {
    return switch (key) {
      'business' => Icons.business_center_outlined,
      'family' => Icons.diversity_1_outlined,
      'home' => Icons.home_work_outlined,
      'public' => Icons.public_outlined,
      'gavel' => Icons.gavel_outlined,
      'shield' => Icons.shield_outlined,
      'work' => Icons.badge_outlined,
      'account_balance' => Icons.account_balance_outlined,
      _ => Icons.balance_outlined,
    };
  }
}
