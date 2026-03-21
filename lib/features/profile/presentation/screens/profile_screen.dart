import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/icons/app_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final br = theme.brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil', style: theme.textTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.s12,
          AppSpacing.page,
          AppSpacing.s48,
        ),
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppRadii.xl),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.65)),
              boxShadow: AppShadows.card(br),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: scheme.primary.withValues(alpha: 0.12),
                    child: Icon(
                      AppLucideUi.user,
                      size: 48,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    'Seu nome',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  Text(
                    '@usuario',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'CONTA',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.s12),
          _ProfileRow(
            icon: AppLucideUi.settings,
            title: 'Configurações',
            onTap: () => context.push('/profile/settings'),
            scheme: scheme,
            theme: theme,
          ),
          const SizedBox(height: AppSpacing.s6),
          _ProfileRow(
            icon: AppLucideUi.logOut,
            title: 'Sair',
            onTap: () => context.go('/auth/login'),
            scheme: scheme,
            theme: theme,
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.scheme,
    required this.theme,
    this.emphasize = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final ColorScheme scheme;
  final ThemeData theme;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final fg = emphasize ? scheme.primary : scheme.onSurface;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: scheme.outline.withValues(alpha: 0.65)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s18,
              vertical: AppSpacing.s12,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: AppIconSizes.list,
                  color: emphasize ? scheme.primary : scheme.onSurface.withValues(alpha: 0.75),
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  AppLucideUi.chevronRight,
                  size: AppIconSizes.inline,
                  color: fg.withValues(alpha: 0.35),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
