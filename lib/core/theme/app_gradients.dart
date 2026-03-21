import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppGradients {
  static const Alignment brandBegin = Alignment(-0.9, -0.95);
  static const Alignment brandEnd = Alignment(0.85, 0.95);

  static const LinearGradient brandPrimary = LinearGradient(
    begin: brandBegin,
    end: brandEnd,
    colors: [
      AppColors.lightAccent,
      AppColors.lightAccentStrong,
    ],
  );

  static const LinearGradient brandSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.lightAccent,
      AppColors.lightAccentStrong,
    ],
  );

  static const LinearGradient fabBible = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1),
      Color(0xFF8B5CF6),
    ],
  );

  static const LinearGradient brandPrimaryDark = LinearGradient(
    begin: brandBegin,
    end: brandEnd,
    colors: [
      AppColors.darkAccentStrong,
      AppColors.darkAccent,
    ],
  );

  static LinearGradient cardTopAccent(Brightness brightness) =>
      brightness == Brightness.dark ? brandPrimaryDark : brandSoft;

  static Color brandShadowTint(Brightness brightness) {
    return brightness == Brightness.dark
        ? AppColors.darkAccent.withValues(alpha: 0.35)
        : AppColors.lightAccent.withValues(alpha: 0.12);
  }
}
