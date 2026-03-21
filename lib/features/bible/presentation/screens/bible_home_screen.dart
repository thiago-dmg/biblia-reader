import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/icons/app_icons.dart';
import '../../../../shared/widgets/app_list_row_card.dart';

class BibleHomeScreen extends StatelessWidget {
  const BibleHomeScreen({super.key});

  static const _books = [
    ('Gênesis', 'GEN', 50),
    ('Salmos', 'PSA', 150),
    ('João', 'JHN', 21),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bíblia', style: theme.textTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.s12,
          AppSpacing.page,
          AppSpacing.s48,
        ),
        children: [
          Text(
            'Texto sagrado',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.s6),
          Text(
            'Tipografia pensada para leitura longa. Escolha um livro.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          ..._books.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s12),
              child: AppListRowCard(
                title: b.$1,
                subtitle: '${b.$3} capítulos',
                trailingBadge: b.$2,
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(
                    AppLucideUi.bookMarked,
                    size: AppIconSizes.list,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                onTap: () => context.push('/bible/read/${b.$2}/1'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
