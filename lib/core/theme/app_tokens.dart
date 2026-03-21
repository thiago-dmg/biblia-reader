import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_gradients.dart';

/// Ritmo **6 / 8 / 12** — base 6 para alinhamento fino + saltos 8/12.
abstract final class AppSpacing {
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s30 = 30;
  static const double s32 = 32;
  static const double s36 = 36;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double page = 22;
}

abstract final class AppRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 18;
  static const double xl = 20;
  static const double sheet = 24;
  static const double full = 999;
}

abstract final class AppShadows {
  /// Cartão: sombras em camadas + halo discreto da cor da marca.
  static List<BoxShadow> card(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.45),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: AppGradients.brandShadowTint(Brightness.dark),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return [
      BoxShadow(
        color: AppColors.lightTextPrimary.withValues(alpha: 0.055),
        blurRadius: 28,
        offset: const Offset(0, 12),
      ),
      BoxShadow(
        color: AppGradients.brandShadowTint(Brightness.light),
        blurRadius: 18,
        offset: const Offset(0, 5),
      ),
      BoxShadow(
        color: AppColors.lightTextPrimary.withValues(alpha: 0.02),
        blurRadius: 6,
        offset: const Offset(0, 1),
      ),
    ];
  }

  /// Barra inferior (dock).
  static List<BoxShadow> dockLift() => [
        BoxShadow(
          color: AppColors.lightTextPrimary.withValues(alpha: 0.07),
          blurRadius: 30,
          offset: const Offset(0, -8),
        ),
        BoxShadow(
          color: AppColors.lightAccent.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, -3),
        ),
      ];

  /// FAB central (elevação + halo).
  static List<BoxShadow> fabHero(Brightness brightness, {required bool selected}) {
    final base = brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.5)
        : AppColors.lightTextPrimary.withValues(alpha: 0.16);
    final glowAlpha = brightness == Brightness.dark
        ? (selected ? 0.42 : 0.28)
        : (selected ? 0.2 : 0.12);
    final glowColor = brightness == Brightness.dark
        ? AppColors.darkAccent.withValues(alpha: glowAlpha)
        : AppColors.lightAccent.withValues(alpha: glowAlpha);
    return [
      BoxShadow(
        color: glowColor,
        blurRadius: selected ? 22 : 16,
        spreadRadius: selected ? 0.5 : 0,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: base,
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }
}

abstract final class AppIconSizes {
  static const double nav = 22;
  static const double navActive = 24;
  static const double list = 21;
  static const double inline = 19;
}
