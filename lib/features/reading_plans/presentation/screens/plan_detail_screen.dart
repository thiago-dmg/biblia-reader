import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/widgets/app_progress_track.dart';
import '../../domain/entities/reading_plan.dart';
import '../../domain/services/bible_book_labels_pt.dart';
import '../../domain/services/bible_reading_plan_presets.dart';
import '../../domain/services/canonical_bible_chapter_order.dart';
import '../../domain/services/reading_plan_progress_calculator.dart';

class PlanDetailScreen extends ConsumerStatefulWidget {
  const PlanDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  ConsumerState<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends ConsumerState<PlanDetailScreen> {
  late DateTime _visibleMonth;
  int _planGeneration = 0;
  bool _registeringToday = false;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    _visibleMonth = DateTime(n.year, n.month);
  }

  static const _monthsPtUpper = <String>[
    'JANEIRO',
    'FEVEREIRO',
    'MARÇO',
    'ABRIL',
    'MAIO',
    'JUNHO',
    'JULHO',
    'AGOSTO',
    'SETEMBRO',
    'OUTUBRO',
    'NOVEMBRO',
    'DEZEMBRO',
  ];

  String _monthDayPt(DateTime d) {
    final m = _monthsPtUpper[d.month - 1].toLowerCase();
    return '${d.day} de $m';
  }

  String _monthYearHeader(DateTime m) =>
      '${_monthsPtUpper[m.month - 1]} DE ${m.year}';

  int _completedTodayInList(ReadingPlan plan, List<String> todayKeys, DateTime ref) {
    final d = DateTime(ref.year, ref.month, ref.day);
    for (final s in plan.sessions) {
      final sd = DateTime(s.date.year, s.date.month, s.date.day);
      if (sd != d) continue;
      return s.chapterKeys.where(todayKeys.contains).length;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(readingPlanRepositoryProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final br = theme.brightness;
    final df = DateFormat('dd/MM/yyyy');
    final today = DateTime.now();

    return Scaffold(
      body: FutureBuilder<ReadingPlan?>(
        key: ValueKey(_planGeneration),
        future: repo.getById(widget.planId),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (!snap.hasData || snap.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.page),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Plano não encontrado', style: theme.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.s16),
                    FilledButton(
                      onPressed: () => context.pop(),
                      child: const Text('Voltar'),
                    ),
                  ],
                ),
              ),
            );
          }
          final plan = snap.data!;
          final calc = const ReadingPlanProgressCalculator();
          final s = calc.compute(plan, referenceDate: today);
          final cap = plan.pace.chaptersPerDay ?? s.suggestedChaptersToday;
          final totalDays = BibleReadingPlanPresets.displayTotalDays(plan);
          final dayNum = (s.daysElapsed + 1).clamp(1, totalDays);
          final todayKeys = CanonicalBibleChapterOrder.suggestedChapterKeysForToday(
            plan,
            suggestedCount: s.suggestedChaptersToday,
          );
          final doneToday = _completedTodayInList(plan, todayKeys, today);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                ),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      plan.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.primary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$cap capítulos/dia • Dia $dayNum/$totalDays',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.55),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    tooltip: 'Ajustes',
                    onPressed: () => context.push('/home/plans/pick'),
                    icon: Icon(Icons.settings_outlined, color: scheme.primary),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.s12,
                  AppSpacing.page,
                  AppSpacing.s48,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${(s.percentComplete * 100).toStringAsFixed(1)}%',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Text(
                          'de ${s.totalChapters} capítulos',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    AppProgressTrack(value: s.percentComplete, height: 8),
                    const SizedBox(height: AppSpacing.s24),
                    Text(
                      'Calendário de leitura',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    Text(
                      'Dia atual em destaque. Abaixo, os capítulos sugeridos para hoje.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.52),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    _MonthCalendar(
                      month: _visibleMonth,
                      monthYearLabel: _monthYearHeader(_visibleMonth),
                      onPrev: () => setState(() {
                        _visibleMonth = DateTime(
                          _visibleMonth.year,
                          _visibleMonth.month - 1,
                        );
                      }),
                      onNext: () => setState(() {
                        _visibleMonth = DateTime(
                          _visibleMonth.year,
                          _visibleMonth.month + 1,
                        );
                      }),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    Text(
                      'LEITURA DE HOJE',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.45),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _monthDayPt(today),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                        if (todayKeys.isNotEmpty)
                          Text(
                            '$doneToday de ${todayKeys.length} concluídas',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.55),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    if (todayKeys.isEmpty)
                      Text(
                        'Nada pendente hoje ou plano concluído. Parabéns!',
                        style: theme.textTheme.bodyMedium,
                      )
                    else
                      ...todayKeys.map((key) {
                        final parsed = CanonicalBibleChapterOrder.parseKey(key);
                        final bookAbbr = parsed.$1;
                        final ch = parsed.$2;
                        final bookName = bibleBookPortugueseName(bookAbbr);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                          child: _TodayReadingRow(
                            title: '$bookName $ch',
                            subtitle: 'Dia $dayNum',
                            onRead: () => context.push('/bible/read/$bookAbbr/$ch'),
                            scheme: scheme,
                            theme: theme,
                          ),
                        );
                      }),
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
                      onPressed: todayKeys.isEmpty || _registeringToday
                          ? null
                          : () async {
                              setState(() => _registeringToday = true);
                              try {
                                await ref
                                    .read(readingPlanRepositoryProvider)
                                    .addChapterReads(widget.planId, todayKeys);
                                ref.invalidate(readingPlansListProvider);
                                if (!context.mounted) return;
                                setState(() {
                                  _registeringToday = false;
                                  _planGeneration++;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      todayKeys.length == 1
                                          ? '1 capítulo registrado.'
                                          : '${todayKeys.length} capítulos registrados.',
                                    ),
                                  ),
                                );
                              } on ApiException catch (e) {
                                if (!context.mounted) return;
                                setState(() => _registeringToday = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message)),
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                setState(() => _registeringToday = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$e')),
                                );
                              }
                            },
                      child: _registeringToday
                          ? SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: scheme.onPrimary,
                              ),
                            )
                          : const Text('Registrar leitura de hoje'),
                    ),
                  ]),
                ),
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

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.month,
    required this.monthYearLabel,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime month;
  final String monthYearLabel;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final first = DateTime(month.year, month.month);
    final last = DateTime(month.year, month.month + 1, 0);
    final startWeekday = first.weekday % 7;
    final daysInMonth = last.day;
    final today = DateTime.now();
    final isSameMonth =
        today.year == month.year && today.month == month.month;

    const weekLabels = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.65)),
        boxShadow: AppShadows.card(theme.brightness),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.s8, bottom: AppSpacing.s8),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: scheme.primary, size: 22),
                  const SizedBox(width: AppSpacing.s8),
                  Text(
                    monthYearLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.primary,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onPrev,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: Text(
                    monthYearLabel,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            Row(
              children: weekLabels
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface.withValues(alpha: 0.45),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.s8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 1.1,
              ),
              itemCount: 42,
              itemBuilder: (context, i) {
                final dayNum = i - startWeekday + 1;
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const SizedBox.shrink();
                }
                final isToday = isSameMonth && dayNum == today.day;
                return Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isToday ? scheme.primary : null,
                    ),
                    child: Text(
                      '$dayNum',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                        color: isToday ? scheme.onPrimary : scheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayReadingRow extends StatelessWidget {
  const _TodayReadingRow({
    required this.title,
    required this.subtitle,
    required this.onRead,
    required this.scheme,
    required this.theme,
  });

  final String title;
  final String subtitle;
  final VoidCallback onRead;
  final ColorScheme scheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scheme.surface,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s8,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: AppGradients.fabBible,
              ),
              child: const Icon(
                Icons.circle_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.52),
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onRead,
                borderRadius: BorderRadius.circular(AppRadii.sm),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: AppGradients.fabBible,
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s16,
                      vertical: AppSpacing.s8,
                    ),
                    child: Text(
                      'Ler',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
