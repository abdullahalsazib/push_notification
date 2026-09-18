import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Mode Colors
  static const Color _lightBg = Color(0xFFF8FAFC);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightPrimary = Color(0xFF2563EB);
  static const Color _lightText = Color(0xFF0F172A);
  static const Color _lightSecText = Color(0xFF64748B);
  static const Color _lightBorder = Color(0xFFE2E8F0);

  static const Color _error = Color(0xFFDC2626);

  // Dark Mode Colors
  static const Color _darkBg = Color(0xFF0B1120);
  static const Color _darkSurface = Color(0xFF111827);
  static const Color _darkElevated = Color(0xFF172033);
  static const Color _darkPrimary = Color(0xFF60A5FA);
  static const Color _darkText = Color(0xFFF8FAFC);
  static const Color _darkSecText = Color(0xFF94A3B8);
  static const Color _darkBorder = Color(0xFF263244);

  static const Color _darkError = Color(0xFFF87171);

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: _lightPrimary,
        surface: _lightSurface,
        surfaceContainerLowest: _lightBg,
        onSurface: _lightText,
        onSurfaceVariant: _lightSecText,
        outline: _lightBorder,
        error: _error,
      ),
      scaffoldBackgroundColor: _lightBg,
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(color: _lightText),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: _lightText,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(color: _lightText),
        titleSmall: textTheme.titleSmall?.copyWith(color: _lightText),
        bodyLarge: textTheme.bodyLarge?.copyWith(color: _lightText),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: _lightSecText),
        bodySmall: textTheme.bodySmall?.copyWith(color: _lightSecText),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _lightBg,
        foregroundColor: _lightText,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _lightBg,
        indicatorColor: _lightPrimary.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: _lightPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: _lightSecText,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _lightPrimary);
          }
          return const IconThemeData(color: _lightSecText);
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _darkPrimary,
        surface: _darkSurface,
        surfaceContainerHighest: _darkElevated,
        surfaceContainerLowest: _darkBg,
        onSurface: _darkText,
        onSurfaceVariant: _darkSecText,
        outline: _darkBorder,
        error: _darkError,
      ),
      scaffoldBackgroundColor: _darkBg,
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(color: _darkText),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: _darkText,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(color: _darkText),
        titleSmall: textTheme.titleSmall?.copyWith(color: _darkText),
        bodyLarge: textTheme.bodyLarge?.copyWith(color: _darkText),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: _darkSecText),
        bodySmall: textTheme.bodySmall?.copyWith(color: _darkSecText),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _darkBg,
        foregroundColor: _darkText,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkElevated,
        indicatorColor: _darkPrimary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: _darkPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: _darkSecText,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _darkPrimary);
          }
          return const IconThemeData(color: _darkSecText);
        }),
      ),
    );
  }
}
