import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_tokens.dart';

/// Cartão premium: raio amplo, borda neutra, filete em **gradiente multi-stop** da marca.
class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.s20),
    this.showTopAccent = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool showTopAccent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final br = Theme.of(context).brightness;
    final isLight = br == Brightness.light;
    final radius = BorderRadius.circular(AppRadii.xl);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: isLight
                  ? AppColors.lightBorder.withValues(alpha: 0.95)
                  : AppColors.darkBorder.withValues(alpha: 0.9),
              width: 1,
            ),
            boxShadow: AppShadows.card(br),
            color: scheme.surface,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showTopAccent)
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: AppGradients.cardTopAccent(br),
                    ),
                  ),
                Padding(
                  padding: padding,
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
