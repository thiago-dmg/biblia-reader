import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/icons/app_icons.dart';
import '../../../../shared/widgets/app_progress_track.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../reading_plans/domain/services/reading_plan_progress_calculator.dart';

/// Home com hierarquia clara: boas-vindas, versículo, plano ativo e **grade de acesso rápido**.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPlans = ref.watch(readingPlansListProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final calc = const ReadingPlanProgressCalculator();
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.page,
                top + AppSpacing.s16,
                AppSpacing.page,
                AppSpacing.s8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bem-vindo(a)',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s8),
                        Text(
                          'Continue sua jornada de fé hoje.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor:
                          scheme.primaryContainer.withValues(alpha: 0.72),
                      foregroundColor: scheme.primary,
                    ),
                    icon: const Icon(AppLucideUi.bell),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.s24,
                AppSpacing.page,
                AppSpacing.s8,
              ),
              child: PremiumCard(
                onTap: () => context.push('/bible'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer
                                .withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(AppRadii.sm),
                          ),
                          child: Icon(
                            AppLucideUi.bookOpen,
                            size: 20,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Text(
                          'VERSÍCULO DO DIA',
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Text(
                      '"Porque eu bem sei os pensamentos que tenho a vosso respeito", '
                      'diz o Senhor: "pensamentos de paz e não de mal, para vos dar o '
                      'fim que desejais."',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        height: 1.5,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      '— Jeremias 29:11',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.s24,
                AppSpacing.page,
                AppSpacing.s12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PLANO ATIVO',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Continuidade',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/plans'),
                        child: const Text('Ver planos'),
                      ),
                    ],
                  ),
                  Text(
                    'Metas recalculadas automaticamente.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
            sliver: SliverToBoxAdapter(
              child: asyncPlans.when(
                data: (plans) {
                  if (plans.isEmpty) {
                    return PremiumCard(
                      onTap: () => context.push('/plans/new'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Começar um plano',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Text(
                            'Defina ritmo e escopo — ajustamos as metas por você.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final p = plans.first;
                  final snap =
                      calc.compute(p, referenceDate: DateTime.now());
                  final pct = snap.percentComplete;
                  return PremiumCard(
                    onTap: () => context.push('/plans/${p.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.s12,
                                      vertical: AppSpacing.s6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: scheme.primaryContainer
                                          .withValues(alpha: 0.92),
                                      borderRadius:
                                          BorderRadius.circular(AppRadii.sm),
                                      border: Border.all(
                                        color: scheme.primary
                                            .withValues(alpha: 0.28),
                                      ),
                                    ),
                                    child: Text(
                                      'Ao vivo',
                                      style:
                                          theme.textTheme.labelLarge?.copyWith(
                                        color: scheme.onPrimaryContainer,
                                        fontSize: 10,
                                        letterSpacing: 0.55,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.s12),
                                  Text(
                                    p.title,
                                    style: theme.textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: AppSpacing.s12),
                                  AppProgressTrack(value: pct),
                                  const SizedBox(height: AppSpacing.s12),
                                  Text(
                                    '${(pct * 100).toStringAsFixed(1)}% · '
                                    '${snap.remainingChapters} cap. restantes · '
                                    'hoje: ${snap.suggestedChaptersToday} cap.',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  if (snap.isBehindSchedule) ...[
                                    const SizedBox(height: AppSpacing.s6),
                                    Text(
                                      'Levemente atrasado — ajuste o ritmo quando quiser.',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: theme.brightness ==
                                                Brightness.light
                                            ? AppColors.lightWarning
                                            : AppColors.darkWarning,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s12),
                            SizedBox(
                              width: 86,
                              height: 86,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned.fill(
                                    child: CircularProgressIndicator(
                                      value: pct,
                                      strokeWidth: 6,
                                      strokeCap: StrokeCap.round,
                                      backgroundColor:
                                          scheme.surfaceContainerHighest,
                                      color: scheme.primary,
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                    ),
                                  ),
                                  Text(
                                    '${(pct * 100).round()}%',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: scheme.primary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.s36),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
                error: (e, _) => Text('Erro: $e'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.s32,
                AppSpacing.page,
                AppSpacing.s12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACESSO RÁPIDO',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    'O que você precisa agora',
                    style: theme.textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
            sliver: SliverToBoxAdapter(
              child: _QuickAccessGrid(
                onCommunity: () => context.go('/community'),
                onGoals: () => context.push('/home/goals'),
                onSupport: () => context.push('/home/support'),
                onBible: () => context.go('/bible'),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.s40 + 56),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({
    required this.onCommunity,
    required this.onGoals,
    required this.onSupport,
    required this.onBible,
  });

  final VoidCallback onCommunity;
  final VoidCallback onGoals;
  final VoidCallback onSupport;
  final VoidCallback onBible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final items = <({
      String label,
      IconData icon,
      VoidCallback onTap,
    })>[
      (label: 'Comunidade', icon: AppLucideUi.messagesSquare, onTap: onCommunity),
      (label: 'Metas', icon: AppLucideUi.flag, onTap: onGoals),
      (label: 'Suporte', icon: AppLucideUi.headphones, onTap: onSupport),
      (label: 'Bíblia', icon: AppLucideUi.bookOpen, onTap: onBible),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final gap = AppSpacing.s12;
        final cellW = (w - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items.map((e) {
            return SizedBox(
              width: cellW,
              child: _QuickTile(
                label: e.label,
                icon: e.icon,
                onTap: e.onTap,
                scheme: scheme,
                theme: theme,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.scheme,
    required this.theme,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme scheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final br = theme.brightness;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.xl),
            border: Border.all(
              color: scheme.outline.withValues(alpha: 0.88),
            ),
            boxShadow: AppShadows.card(br),
            color: scheme.surface,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primaryContainer.withValues(alpha: 0.75),
                    border: Border.all(
                      color: scheme.primary.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: scheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
