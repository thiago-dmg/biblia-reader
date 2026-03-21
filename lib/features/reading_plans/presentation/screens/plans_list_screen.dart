import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/biblia_auth.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/icons/app_icons.dart';
import '../../domain/entities/reading_plan.dart';
import '../../domain/entities/reading_plan_pace.dart';

class PlansListScreen extends ConsumerWidget {
  const PlansListScreen({super.key});

  static String _paceLine(ReadingPlan p) {
    final pace = p.pace;
    switch (pace.mode) {
      case ReadingPaceMode.chaptersPerDay:
        final c = pace.chaptersPerDay ?? 1;
        return '$c capítulos por dia — ritmo equilibrado';
      case ReadingPaceMode.finishByDate:
        return 'Meta por data — ritmo equilibrado';
      case ReadingPaceMode.durationDays:
        final d = pace.durationDays ?? 0;
        return '$d dias — ritmo moderado';
    }
  }

  static String _paceBadge(ReadingPlan p) {
    final pace = p.pace;
    if (pace.mode == ReadingPaceMode.chaptersPerDay) {
      final c = pace.chaptersPerDay ?? 1;
      if (c <= 3) return 'Tranquilo';
      if (c <= 5) return 'Moderado';
      return 'Intenso';
    }
    if (pace.mode == ReadingPaceMode.durationDays) {
      final d = pace.durationDays ?? 365;
      if (d >= 300) return 'Tranquilo';
      if (d >= 120) return 'Moderado';
      return 'Intenso';
    }
    return 'Equilibrado';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(readingPlansListProvider);
    final progressAsync = ref.watch(canonicalReadingProgressProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return async.when(
      data: (plans) {
        final progress = progressAsync.valueOrNull;
        ReadingPlan? current;
        final sid = progress?.selectedPlanId;
        if (sid != null && sid.isNotEmpty) {
          for (final p in plans) {
            if (p.id == sid) {
              current = p;
              break;
            }
          }
        }
        current ??= plans.isNotEmpty ? plans.first : null;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 132,
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: theme.brightness == Brightness.dark
                          ? AppGradients.brandPrimaryDark
                          : LinearGradient(
                              begin: AppGradients.brandBegin,
                              end: AppGradients.brandEnd,
                              colors: [
                                scheme.primary,
                                scheme.secondary.withValues(alpha: 0.92),
                              ],
                            ),
                    ),
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.fromLTRB(20, 88, 20, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Escolha seu Plano',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: scheme.onPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Selecione o ritmo ideal para sua jornada bíblica',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onPrimary.withValues(alpha: 0.88),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.s16,
                  AppSpacing.page,
                  120,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(AppRadii.lg),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, color: scheme.primary),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Text(
                              'Dica: Você pode trocar de plano a qualquer momento. '
                              'Seu progresso será mantido.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                height: 1.45,
                                color: scheme.onSurface.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s20),
                    if (plans.isEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nenhum plano ainda',
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: AppSpacing.s12),
                          FilledButton.icon(
                            onPressed: () => context.push('/home/plans/new'),
                            icon: const Icon(AppLucideUi.plus, size: 20),
                            label: const Text('Criar plano'),
                          ),
                        ],
                      )
                    else
                      ...plans.map((p) {
                        final isSel = current?.id == p.id;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                          child: Material(
                            color: scheme.surface,
                            elevation: isSel ? 2 : 0,
                            shadowColor: Colors.black.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppRadii.lg),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppRadii.lg),
                              onTap: () => context.push('/home/plans/${p.id}'),
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.s16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadii.lg),
                                  border: Border.all(
                                    color: isSel
                                        ? scheme.primary.withValues(alpha: 0.85)
                                        : scheme.outline.withValues(alpha: 0.35),
                                    width: isSel ? 2 : 1,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(14),
                                            gradient: AppGradients.fabBible,
                                          ),
                                          child: const Icon(
                                            AppLucideUi.bookOpen,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.s16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                p.title,
                                                style: theme.textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              if (isSel) ...[
                                                const SizedBox(height: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: scheme.primaryContainer
                                                        .withValues(alpha: 0.9),
                                                    borderRadius: BorderRadius.circular(999),
                                                  ),
                                                  child: Text(
                                                    'Plano atual',
                                                    style: theme.textTheme.labelSmall?.copyWith(
                                                      color: scheme.onPrimaryContainer,
                                                      fontWeight: FontWeight.w800,
                                                      letterSpacing: 0.2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              const SizedBox(height: AppSpacing.s8),
                                              Text(
                                                _paceLine(p),
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: scheme.onSurface
                                                      .withValues(alpha: 0.65),
                                                  height: 1.35,
                                                ),
                                              ),
                                              const SizedBox(height: AppSpacing.s12),
                                              Wrap(
                                                spacing: 12,
                                                runSpacing: 8,
                                                children: [
                                                  _MetaChip(
                                                    icon: Icons.calendar_today_outlined,
                                                    label: '${p.totalChaptersInScope} cap.',
                                                  ),
                                                  if (p.pace.chaptersPerDay != null)
                                                    _MetaChip(
                                                      icon: Icons.menu_book_outlined,
                                                      label: '${p.pace.chaptersPerDay} cap/dia',
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(height: AppSpacing.s12),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFE8F5E9),
                                                  borderRadius: BorderRadius.circular(999),
                                                ),
                                                child: Text(
                                                  _paceBadge(p),
                                                  style: theme.textTheme.labelSmall?.copyWith(
                                                    color: const Color(0xFF2E7D32),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isSel)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: scheme.primary,
                                          size: 26,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  ]),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push('/home/plans/new'),
            icon: const Icon(AppLucideUi.plus, size: 20),
            label: const Text('Novo plano'),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('$e')),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: scheme.primary.withValues(alpha: 0.85)),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
