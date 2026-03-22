import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/biblia_auth.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/navigation/reading_plan_routes.dart';
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
    final br = theme.brightness;
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
                    onPressed: () => context.go('/support'),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB74D),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.help_outline_rounded),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  IconButton(
                    onPressed: () => context.go('/me'),
                    tooltip: 'Perfil',
                    style: IconButton.styleFrom(
                      backgroundColor:
                          scheme.primaryContainer.withValues(alpha: 0.72),
                      foregroundColor: scheme.primary,
                    ),
                    icon: Icon(AppLucideNav.profile(false)),
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
                AppSpacing.s18,
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
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.s20,
              AppSpacing.page,
              AppSpacing.s8,
            ),
            sliver: SliverToBoxAdapter(
              child: asyncPlans.when(
                data: (plans) {
                  if (plans.isEmpty) {
                    return _BiblicalProgressCard(
                      scheme: scheme,
                      br: br,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => openChoosePlanScreen(context, ref),
                                borderRadius: BorderRadius.circular(AppRadii.md),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4, bottom: 4),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const _ProgressSquareIcon(),
                                          const SizedBox(width: AppSpacing.s16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Começar um plano',
                                                  style: theme.textTheme.titleLarge?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(height: AppSpacing.s8),
                                                Text(
                                                  showLoginCta
                                                      ? 'Escolha 1 ano, 6 meses ou 90 dias — ou entre para sincronizar na nuvem.'
                                                      : 'Defina ritmo e escopo — ajustamos as metas por você.',
                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                    color: scheme.onSurface.withValues(alpha: 0.55),
                                                    height: 1.35,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.s16),
                                      AppProgressTrack(value: 0, height: 6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _TrocarPlanoColumn(
                            scheme: scheme,
                            theme: theme,
                            onTap: () => openChoosePlanScreen(context, ref),
                          ),
                        ],
                      ),
                    );
                  }
                  final p = plans.first;
                  final snap =
                      calc.compute(p, referenceDate: DateTime.now());
                  final pct = snap.percentComplete;
                  final capDay = p.pace.chaptersPerDay ?? 1;
                  return _BiblicalProgressCard(
                    scheme: scheme,
                    br: br,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => context.push('/home/plans/${p.id}'),
                              borderRadius: BorderRadius.circular(AppRadii.md),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4, bottom: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const _ProgressSquareIcon(),
                                        const SizedBox(width: AppSpacing.s16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Seu progresso bíblico',
                                                style: theme.textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                  color: scheme.onSurface,
                                                ),
                                              ),
                                              const SizedBox(height: AppSpacing.s8),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                                textBaseline: TextBaseline.alphabetic,
                                                children: [
                                                  Text(
                                                    '${(pct * 100).round()}%',
                                                    style: theme.textTheme.headlineMedium?.copyWith(
                                                      color: scheme.primary,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                  const SizedBox(width: AppSpacing.s8),
                                                  Text(
                                                    'concluído',
                                                    style: theme.textTheme.bodyLarge?.copyWith(
                                                      color: scheme.onSurface.withValues(alpha: 0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: AppSpacing.s8),
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
                                                        fontWeight: FontWeight.w700,
                                                        color: scheme.onSurface.withValues(alpha: 0.72),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppSpacing.s6),
                                    Text(
                                      '$capDay capítulos por dia',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: scheme.onSurface.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.s12),
                                    AppProgressTrack(value: pct, height: 6),
                                    if (snap.isBehindSchedule) ...[
                                      const SizedBox(height: AppSpacing.s8),
                                      Text(
                                        'Levemente atrasado no ritmo — toque para ver o calendário.',
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
                            ),
                          ),
                        ),
                        _TrocarPlanoColumn(
                          scheme: scheme,
                          theme: theme,
                          onTap: () => openChoosePlanScreen(context, ref),
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
                AppSpacing.s24,
                AppSpacing.page,
                AppSpacing.s8,
              ),
              child: Text(
                'Atalhos',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
            sliver: SliverToBoxAdapter(
              child: _QuickAccessGrid(
                onPrayer: () => context.go('/prayer'),
                onCommunity: () => context.go('/community'),
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

class _BiblicalProgressCard extends StatelessWidget {
  const _BiblicalProgressCard({
    required this.scheme,
    required this.br,
    required this.child,
  });

  final ColorScheme scheme;
  final Brightness br;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scheme.surface,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(
            color: scheme.primary.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: AppShadows.card(br),
        ),
        child: child,
      ),
    );
  }
}

class _ProgressSquareIcon extends StatelessWidget {
  const _ProgressSquareIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: AppGradients.fabBible,
      ),
      child: const Icon(
        Icons.show_chart_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

class _TrocarPlanoColumn extends StatelessWidget {
  const _TrocarPlanoColumn({
    required this.scheme,
    required this.theme,
    required this.onTap,
  });

  final ColorScheme scheme;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 4, 2, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                color: scheme.primary,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                'Trocar plano',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({
    required this.onPrayer,
    required this.onCommunity,
    required this.onBible,
  });

  final VoidCallback onPrayer;
  final VoidCallback onCommunity;
  final VoidCallback onBible;

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
      (label: 'Comunidade', icon: AppLucideUi.messagesSquare, onTap: onCommunity, highlight: false),
      (label: 'Bíblia', icon: AppLucideUi.bookOpen, onTap: onBible, highlight: false),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final gap = AppSpacing.s12;
        final cellW = (w - gap * 2) / 3;
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
