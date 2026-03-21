import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/icons/app_icons.dart';
import '../../../../shared/widgets/app_list_row_card.dart';
import '../../../../shared/widgets/app_progress_track.dart';

class PlansListScreen extends ConsumerWidget {
  const PlansListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(readingPlansListProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Planos', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(AppLucideUi.plus),
            onPressed: () => context.push('/plans/new'),
          ),
        ],
      ),
      body: async.when(
        data: (plans) {
          if (plans.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.page),
              children: [
                Text(
                  'Nenhum plano ainda',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.s12),
                Text(
                  'Crie um ritmo: o app recalcula metas todos os dias.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.52),
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                FilledButton.icon(
                  onPressed: () => context.push('/plans/new'),
                  icon: const Icon(AppLucideUi.plus, size: 20),
                  label: const Text('Criar plano'),
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.s12,
              AppSpacing.page,
              100,
            ),
            children: [
              Text(
                'Seus planos',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.s6),
              Text(
                '${plans.length} ${plans.length == 1 ? 'ativo' : 'ativos'}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.s24),
              ...plans.map((p) {
                final pct = p.totalChaptersInScope > 0
                    ? p.completedCount / p.totalChaptersInScope
                    : 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                  child: AppListRowCard(
                    title: p.title,
                    subtitle:
                        '${p.completedCount} de ${p.totalChaptersInScope} capítulos',
                    footer: AppProgressTrack(value: pct, height: 5),
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: scheme.primaryContainer,
                      child: Icon(
                        AppLucideUi.signpost,
                        size: AppIconSizes.list,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                    onTap: () => context.push('/plans/${p.id}'),
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('$e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/plans/new'),
        icon: const Icon(AppLucideUi.plus, size: 20),
        label: const Text('Novo plano'),
      ),
    );
  }
}
