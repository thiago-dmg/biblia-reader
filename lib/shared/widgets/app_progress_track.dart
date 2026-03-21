import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_tokens.dart';

/// Trilha com preenchimento em **gradiente da marca** (violeta → teal contido).
class AppProgressTrack extends StatelessWidget {
  const AppProgressTrack({
    super.key,
    required this.value,
    this.height = 7,
  });

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final br = Theme.of(context).brightness;
    final v = value.clamp(0.0, 1.0);
    final track = br == Brightness.light
        ? AppColors.lightSurfaceSecondary
        : AppColors.darkSurfaceSecondary;
    final gradient = br == Brightness.light
        ? AppGradients.brandSoft
        : AppGradients.brandPrimaryDark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.full),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: track),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: v,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: gradient,
                  boxShadow: [
                    BoxShadow(
                      color: (br == Brightness.light
                              ? AppColors.lightAccent
                              : AppColors.darkAccent)
                          .withValues(alpha: br == Brightness.light ? 0.2 : 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
