import 'package:flutter/material.dart';

/// Исламский дневник — тёплые, спокойные тона.
class QadamTheme {
  static const Color primary = Color(0xFF3F7D4E);
  static const Color background = Color(0xFFF8F7F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF6B6B6B);

  static const Color weekGreen = Color(0xFF3F7D4E);
  static const Color weekYellow = Color(0xFFD4A017);
  static const Color weekRed = Color(0xFFC94F4F);
  static const Color weekCurrent = Color(0xFF2A5F8F);
  static const Color weekFuture = Color(0xFFE8E6DF);
  static const Color weekEmpty = Color(0xFFD9D7D0);

  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      secondary: weekYellow,
      surface: surface,
      onSurface: textPrimary,
      outline: Color(0xFFE0DDD4),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        labelMedium: TextStyle(color: textSecondary, fontSize: 13),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: background,
        foregroundColor: textPrimary,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFEDEAE3)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEDEAE3),
        space: 1,
        thickness: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary);
          }
          return const IconThemeData(color: textSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            );
          }
          return const TextStyle(fontSize: 12, color: textSecondary);
        }),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primary,
        thumbColor: primary,
        inactiveTrackColor: Color(0xFFE0DDD4),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }
}
