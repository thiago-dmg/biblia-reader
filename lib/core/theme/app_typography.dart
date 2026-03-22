import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// **Playfair Display** em todo o app (títulos e corpo), com pesos distintos.
abstract final class AppTypography {
  static TextTheme lightTextTheme(ColorScheme scheme) {
    final display = GoogleFonts.playfairDisplay(
      color: scheme.onSurface,
      fontWeight: FontWeight.w600,
      height: 1.35,
    );
    final body = GoogleFonts.playfairDisplay(
      color: scheme.onSurface,
      height: 1.5,
    );
    return TextTheme(
      displayLarge: display.copyWith(
        fontSize: 40,
        height: 1.05,
        letterSpacing: -0.4,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: display.copyWith(
        fontSize: 34,
        height: 1.08,
        letterSpacing: -0.35,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: display.copyWith(
        fontSize: 30,
        height: 1.1,
        letterSpacing: -0.3,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: display.copyWith(
        fontSize: 28,
        height: 1.12,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: display.copyWith(
        fontSize: 24,
        height: 1.15,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: display.copyWith(
        fontSize: 20,
        height: 1.22,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: body.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.15,
        color: scheme.onSurface,
      ),
      titleMedium: body.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.08,
        color: scheme.onSurface,
      ),
      titleSmall: body.copyWith(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: scheme.primary.withValues(alpha: 0.88),
      ),
      bodyLarge: body.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface,
      ),
      bodyMedium: body.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: scheme.onSurfaceVariant,
      ),
      bodySmall: body.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: scheme.onSurfaceVariant,
        height: 1.45,
      ),
      labelLarge: body.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.06,
        color: scheme.onSurface,
      ),
    );
  }

  static TextTheme darkTextTheme(ColorScheme scheme) {
    final display = GoogleFonts.playfairDisplay(
      color: scheme.onSurface,
      fontWeight: FontWeight.w600,
      height: 1.35,
    );
    final body = GoogleFonts.playfairDisplay(
      color: scheme.onSurface,
      height: 1.5,
    );
    return TextTheme(
      displayLarge: display.copyWith(
        fontSize: 40,
        height: 1.05,
        letterSpacing: -0.4,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: display.copyWith(
        fontSize: 34,
        height: 1.08,
        letterSpacing: -0.35,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: display.copyWith(
        fontSize: 30,
        height: 1.1,
        letterSpacing: -0.3,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: display.copyWith(
        fontSize: 28,
        height: 1.12,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: display.copyWith(
        fontSize: 24,
        height: 1.15,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: display.copyWith(
        fontSize: 20,
        height: 1.22,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: body.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.15,
        color: scheme.onSurface,
      ),
      titleMedium: body.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.08,
        color: scheme.onSurface,
      ),
      titleSmall: body.copyWith(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: scheme.primary.withValues(alpha: 0.88),
      ),
      bodyLarge: body.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface,
      ),
      bodyMedium: body.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: scheme.onSurfaceVariant,
      ),
      bodySmall: body.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: scheme.onSurfaceVariant,
        height: 1.45,
      ),
      labelLarge: body.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.06,
        color: scheme.onSurface,
      ),
    );
  }
}
