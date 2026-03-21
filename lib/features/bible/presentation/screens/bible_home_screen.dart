import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/icons/app_icons.dart';
import '../../../../shared/widgets/app_list_row_card.dart';
import '../providers/bible_providers.dart';

class BibleHomeScreen extends ConsumerWidget {
  const BibleHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final asyncBooks = ref.watch(bibleBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bíblia', style: theme.textTheme.titleLarge),
      ),
      body: asyncBooks.when(
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.page),
                child: Text(
                  'Nenhum livro encontrado. Verifique se a API está no ar (Bíblia ACF via /v1/bible).',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.s12,
              AppSpacing.page,
              AppSpacing.s48,
            ),
            children: [
              Text(
                'Almeida Corrigida Fiel (ACF)',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.s6),
              Text(
                'Livros carregados da API. Toque para abrir o capítulo 1.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              ...books.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                  child: AppListRowCard(
                    title: b.name,
                    subtitle: '${b.chapterCount} capítulos',
                    trailingBadge: b.abbreviation,
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: scheme.primaryContainer,
                      child: Icon(
                        AppLucideUi.bookMarked,
                        size: AppIconSizes.list,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                    onTap: () => context.push('/bible/read/${b.abbreviation}/1'),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off, size: 48, color: scheme.error),
                const SizedBox(height: AppSpacing.s12),
                Text(
                  'Não foi possível carregar a Bíblia.\n$e',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
