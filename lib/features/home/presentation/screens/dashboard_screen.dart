import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/biblia_auth.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
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
    final authAsync = ref.watch(authProvider);
    final showLoginCta = authAsync.maybeWhen(
      data: (s) => !s.isAuthenticated,
      orElse: () => false,
    );
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
                    onPressed: () => context.push('/home/support'),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB74D),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.help_outline_rounded),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  IconButton(
                    onPressed: () => context.push('/profile'),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          scheme.primaryContainer.withValues(alpha: 0.72),
                      foregroundColor: scheme.primary,
                    ),
                    icon: Icon(AppLucideNav.profile(false)),
                  ),
                  const SizedBox(width: AppSpacing.s8),
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
          if (showLoginCta)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.s8,
                  AppSpacing.page,
                  AppSpacing.s8,
                ),
                child: Material(
                  color: scheme.primaryContainer.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    onTap: () => context.push('/auth/login'),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      child: Row(
                        children: [
                          Icon(Icons.cloud_outlined, color: scheme.primary),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Entrar na sua conta',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.s6),
                                Text(
                                  'Sincronize planos e progresso com a API.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurface.withValues(alpha: 0.65),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FilledButton(
                            onPressed: () => context.push('/auth/login'),
                            child: const Text('Entrar'),
                          ),
                        ],
                      ),
                    ),
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
                      'fim que esperais."',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        height: 1.5,
                        color: scheme.primary,
                        fontFamily: theme.textTheme.titleLarge?.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '— Jeremias 29:11',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: scheme.primary,
                        ),
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
                    'SEU PROGRESSO BÍBLICO',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.55),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
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
                      onTap: () {
                        if (showLoginCta) {
                          context.push('/auth/login');
                        } else {
                          context.push('/home/plans/new');
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Começar um plano',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Text(
                            showLoginCta
                                ? 'Entre na sua conta para criar planos e acompanhar o progresso.'
                                : 'Defina ritmo e escopo — ajustamos as metas por você.',
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
                    onTap: () => context.push('/home/plans/${p.id}'),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            gradient: AppGradients.fabBible,
                          ),
                          child: const Icon(
                            Icons.show_chart_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Seu Progresso Bíblico',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurface.withValues(alpha: 0.55),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '${(pct * 100).round()}%',
                                    style: theme.textTheme.displaySmall?.copyWith(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'concluído',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: scheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.s12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu_book_outlined,
                                    size: 18,
                                    color: scheme.secondary,
                                  ),
                                  const SizedBox(width: AppSpacing.s6),
                                  Expanded(
                                    child: Text(
                                      p.title,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.s8),
                              AppProgressTrack(value: pct, height: 5),
                              if (snap.isBehindSchedule) ...[
                                const SizedBox(height: AppSpacing.s6),
                                Text(
                                  'Levemente atrasado…',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.brightness == Brightness.light
                                        ? AppColors.lightWarning
                                        : AppColors.darkWarning,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              size: 22,
                              color: scheme.onSurface.withValues(alpha: 0.45),
                            ),
                            TextButton(
                              onPressed: () => context.push('/home/plans'),
                              child: Text(
                                'Trocar plano',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
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
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.55),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    'Atalhos úteis',
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
                onPrayer: () => context.go('/prayer'),
                onStudies: () => context.go('/studies'),
                onSos: () => context.go('/sos'),
                onSupport: () => context.push('/home/support'),
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
    required this.onPrayer,
    required this.onStudies,
    required this.onSos,
    required this.onSupport,
  });

  final VoidCallback onPrayer;
  final VoidCallback onStudies;
  final VoidCallback onSos;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final items = <({
      String label,
      IconData icon,
      VoidCallback onTap,
      bool highlight,
    })>[
      (label: 'Orações', icon: AppLucideNav.prayer(false), onTap: onPrayer, highlight: false),
      (label: 'Estudos', icon: AppLucideUi.penLine, onTap: onStudies, highlight: false),
      (label: 'SOS', icon: AppLucideNav.sosNav(false), onTap: onSos, highlight: false),
      (label: 'Apoiar', icon: Icons.volunteer_activism_rounded, onTap: onSupport, highlight: true),
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
                highlight: e.highlight,
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
    this.highlight = false,
    required this.scheme,
    required this.theme,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlight;
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
              color: highlight
                  ? const Color(0xFFFFCDD2)
                  : scheme.outline.withValues(alpha: 0.88),
              width: highlight ? 1.5 : 1,
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
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFE3F2FD),
                    border: Border.all(
                      color: scheme.primary.withValues(alpha: 0.15),
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
                    color: scheme.primary,
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
