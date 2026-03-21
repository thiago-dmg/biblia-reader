import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/widgets/app_progress_track.dart';
import '../../domain/services/reading_plan_progress_calculator.dart';

class PlanDetailScreen extends ConsumerWidget {
  const PlanDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(readingPlanRepositoryProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final br = theme.brightness;
    final df = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text('Plano', style: theme.textTheme.titleLarge),
      ),
      body: FutureBuilder(
        future: repo.getById(planId),
        builder: (context, snap) {
          if (!snap.hasData || snap.data == null) {
            return const Center(child: Text('Plano não encontrado'));
          }
          final plan = snap.data!;
          final calc = const ReadingPlanProgressCalculator();
          final s = calc.compute(plan, referenceDate: DateTime.now());

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.s12,
              AppSpacing.page,
              AppSpacing.s48,
            ),
            children: [
              Text(
                plan.title,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.s6),
              Text(
                s.isBehindSchedule
                    ? 'Pouco abaixo da meta — ajuste o ritmo quando quiser.'
                    : 'No ritmo. Continue assim.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.52),
                ),
              ),
              const SizedBox(height: AppSpacing.s18),
              AppProgressTrack(value: s.percentComplete, height: 8),
              const SizedBox(height: AppSpacing.s24),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(
                    color: scheme.outline.withValues(alpha: 0.7),
                  ),
                  boxShadow: AppShadows.card(br),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s18),
                  child: Column(
                    children: [
                      _StatRow('Progresso', '${(s.percentComplete * 100).toStringAsFixed(1)}%'),
                      _divider(scheme),
                      _StatRow('Restantes', '${s.remainingChapters} capítulos'),
                      _divider(scheme),
                      _StatRow('Sugestão hoje', '${s.suggestedChaptersToday} capítulos'),
                      _divider(scheme),
                      _StatRow('Previsão de término', df.format(s.effectiveTargetEnd)),
                      _divider(scheme),
                      _StatRow('Dias estimados', '${s.estimatedDaysRemaining}'),
                      _divider(scheme),
                      _StatRow(
                        'Status',
                        s.isBehindSchedule ? 'Ajuste sugerido' : 'No ritmo',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              FilledButton(
                onPressed: () {},
                child: const Text('Registrar leitura de hoje'),
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _divider(ColorScheme scheme) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
        child: Divider(
          height: 1,
          color: scheme.outline.withValues(alpha: 0.45),
        ),
      );
}

class _StatRow extends StatelessWidget {
  const _StatRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
