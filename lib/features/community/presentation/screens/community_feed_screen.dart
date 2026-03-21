import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/icons/app_icons.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final br = theme.brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text('Comunidade', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(AppLucideUi.penLine),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.s12,
          AppSpacing.page,
          AppSpacing.s48,
        ),
        itemCount: 5,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.s18),
        itemBuilder: (context, i) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppRadii.lg),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.72)),
              boxShadow: AppShadows.card(br),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: scheme.primary.withValues(alpha: 0.12),
                        child: Text(
                          'U',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: scheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Usuário $i',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              'Há ${i + 1} h',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    'Reflexão de exemplo sobre gratidão e provisão — texto curto para layout.',
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Row(
                    children: [
                      _PostAction(
                        icon: AppLucideUi.heart,
                        label: '12',
                        theme: theme,
                        scheme: scheme,
                      ),
                      const SizedBox(width: AppSpacing.s18),
                      _PostAction(
                        icon: AppLucideUi.messageCircle,
                        label: '3',
                        theme: theme,
                        scheme: scheme,
                      ),
                      const Spacer(),
                      Icon(
                        AppLucideUi.bookmark,
                        size: AppIconSizes.inline,
                        color: scheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PostAction extends StatelessWidget {
  const _PostAction({
    required this.icon,
    required this.label,
    required this.theme,
    required this.scheme,
  });

  final IconData icon;
  final String label;
  final ThemeData theme;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppRadii.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s6,
          vertical: AppSpacing.s6,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppIconSizes.inline,
              color: scheme.onSurface.withValues(alpha: 0.45),
            ),
            const SizedBox(width: AppSpacing.s6),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
