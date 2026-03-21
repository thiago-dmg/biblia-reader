import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/biblia_auth.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/icons/app_icons.dart';
import '../../../../shared/widgets/name_avatar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final br = theme.brightness;
    final auth = ref.watch(authProvider).valueOrNull;
    final displayName = auth?.displayName.isNotEmpty == true ? auth!.displayName : 'Convidado';
    final subtitle = auth?.isAuthenticated == true ? 'Conta ativa' : 'Sem login — dados locais';

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
                  NameAvatar(
                    name: displayName,
                    radius: 48,
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    displayName,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  Text(
                    subtitle,
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
          if (auth?.isAuthenticated == true)
            _ProfileRow(
              icon: AppLucideUi.logOut,
              title: 'Sair',
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/auth/login');
              },
              scheme: scheme,
              theme: theme,
              emphasize: true,
            )
          else
            _ProfileRow(
              icon: AppLucideUi.user,
              title: 'Entrar ou criar conta',
              onTap: () => context.push('/auth/login'),
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
