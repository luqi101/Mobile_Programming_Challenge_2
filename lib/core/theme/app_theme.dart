import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const navy = Color(0xFF0B1F3A);
  static const charcoal = Color(0xFF1F2933);
  static const ivory = Color(0xFFF8F5EF);
  static const gold = Color(0xFFC9A227);
  static const blueGrey = Color(0xFF64748B);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE7E0D4);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: navy,
      brightness: Brightness.light,
      primary: navy,
      secondary: gold,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: ivory,
      fontFamily: 'System',
      appBarTheme: const AppBarTheme(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: gold.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected) ? navy : blueGrey,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surface,
        selectedIconTheme: const IconThemeData(color: navy),
        selectedLabelTextStyle: const TextStyle(
          color: navy,
          fontWeight: FontWeight.w700,
        ),
        unselectedIconTheme: const IconThemeData(color: blueGrey),
        unselectedLabelTextStyle: const TextStyle(color: blueGrey),
        indicatorColor: gold.withValues(alpha: 0.18),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: navy, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: navy,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: navy,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: navy),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: navy,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          height: 1.12,
        ),
        headlineMedium: TextStyle(
          color: navy,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 1.18,
        ),
        titleLarge: TextStyle(
          color: charcoal,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: charcoal,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(color: charcoal, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: charcoal, fontSize: 14, height: 1.45),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
      ),
    );
  }
}
