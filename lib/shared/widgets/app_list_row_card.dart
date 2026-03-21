import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import '../icons/app_icons.dart';

/// Linha premium: ícone em **medalhão** (highlight), borda definida, chevron discreto.
class AppListRowCard extends StatelessWidget {
  const AppListRowCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailingBadge,
    this.footer,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final String? trailingBadge;
  final Widget? footer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final br = theme.brightness;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: Ink(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadii.xl),
            border: Border.all(
              color: scheme.outline.withValues(alpha: 0.95),
              width: 1,
            ),
            boxShadow: AppShadows.card(br),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s18,
              vertical: AppSpacing.s12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppSpacing.s12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.s6),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                      if (footer != null) ...[
                        const SizedBox(height: AppSpacing.s12),
                        footer!,
                      ],
                    ],
                  ),
                ),
                if (trailingBadge != null)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.s12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s8,
                        vertical: AppSpacing.s6,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                        border: Border.all(
                          color: scheme.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        trailingBadge!,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: scheme.onPrimaryContainer,
                          fontSize: 10,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                Icon(
                  AppLucideUi.chevronRight,
                  size: AppIconSizes.inline,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.65),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
