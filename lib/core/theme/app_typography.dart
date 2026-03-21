import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// **Newsreader** (titulação editorial) + **Inter** (interface). Ênfase em peso e cor semântica.
abstract final class AppTypography {
  static TextTheme lightTextTheme(ColorScheme scheme) {
    final editorial = GoogleFonts.newsreader(
      color: scheme.onSurface,
      fontWeight: FontWeight.w600,
    );
    final ui = GoogleFonts.inter(
      color: scheme.onSurface,
      height: 1.45,
    );
    return TextTheme(
      displayLarge: editorial.copyWith(
        fontSize: 40,
        height: 1.02,
        letterSpacing: -0.55,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: editorial.copyWith(
        fontSize: 34,
        height: 1.05,
        letterSpacing: -0.45,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: editorial.copyWith(
        fontSize: 30,
        height: 1.08,
        letterSpacing: -0.38,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: editorial.copyWith(
        fontSize: 28,
        height: 1.12,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: editorial.copyWith(
        fontSize: 24,
        height: 1.15,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: editorial.copyWith(
        fontSize: 20,
        height: 1.22,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: ui.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.22,
      ),
      titleMedium: ui.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.12,
      ),
      titleSmall: ui.copyWith(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.35,
        color: scheme.primary.withValues(alpha: 0.88),
      ),
      bodyLarge: ui.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface,
      ),
      bodyMedium: ui.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: scheme.onSurfaceVariant,
      ),
      bodySmall: ui.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: scheme.onSurfaceVariant,
        height: 1.42,
      ),
      labelLarge: ui.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.08,
      ),
    );
  }

  static TextTheme darkTextTheme(ColorScheme scheme) {
    final editorial = GoogleFonts.newsreader(
      color: scheme.onSurface,
      fontWeight: FontWeight.w600,
    );
    final ui = GoogleFonts.inter(
      color: scheme.onSurface,
      height: 1.45,
    );
    return TextTheme(
      displayLarge: editorial.copyWith(
        fontSize: 40,
        height: 1.02,
        letterSpacing: -0.55,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: editorial.copyWith(
        fontSize: 34,
        height: 1.05,
        letterSpacing: -0.45,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: editorial.copyWith(
        fontSize: 30,
        height: 1.08,
        letterSpacing: -0.38,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: editorial.copyWith(
        fontSize: 28,
        height: 1.12,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: editorial.copyWith(
        fontSize: 24,
        height: 1.15,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: editorial.copyWith(
        fontSize: 20,
        height: 1.22,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: ui.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.22,
      ),
      titleMedium: ui.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.12,
      ),
      titleSmall: ui.copyWith(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.35,
        color: scheme.primary.withValues(alpha: 0.88),
      ),
      bodyLarge: ui.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface,
      ),
      bodyMedium: ui.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: scheme.onSurfaceVariant,
      ),
      bodySmall: ui.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: scheme.onSurfaceVariant,
        height: 1.42,
      ),
      labelLarge: ui.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.08,
      ),
    );
  }
}
