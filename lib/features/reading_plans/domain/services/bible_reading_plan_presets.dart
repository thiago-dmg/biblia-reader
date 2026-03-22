import '../entities/reading_plan.dart';
import '../entities/reading_plan_pace.dart';
import '../entities/reading_plan_scope.dart';
import 'canonical_bible_chapter_order.dart';

/// Presets alinhados ao layout «Divine» (1 ano / 6 meses / 90 dias).
abstract final class BibleReadingPlanPresets {
  static int get _whole => CanonicalBibleChapterOrder.wholeBibleKeys.length;

  static ReadingPlan draftOneYear() => ReadingPlan(
        id: '',
        title: 'Bíblia em 1 Ano',
        scope: const ReadingPlanScope(type: ReadingPlanScopeType.wholeBible),
        pace: const ReadingPlanPace(
          mode: ReadingPaceMode.chaptersPerDay,
          chaptersPerDay: 4,
        ),
        startDate: DateTime.now(),
        totalChaptersInScope: _whole,
        completedChapterKeys: const {},
        sessions: const [],
      );

  static ReadingPlan draftSixMonths() => ReadingPlan(
        id: '',
        title: 'Bíblia em 6 Meses',
        scope: const ReadingPlanScope(type: ReadingPlanScopeType.wholeBible),
        pace: const ReadingPlanPace(
          mode: ReadingPaceMode.chaptersPerDay,
          chaptersPerDay: 7,
        ),
        startDate: DateTime.now(),
        totalChaptersInScope: _whole,
        completedChapterKeys: const {},
        sessions: const [],
      );

  static ReadingPlan draftNinetyDays() => ReadingPlan(
        id: '',
        title: 'Bíblia em 90 Dias',
        scope: const ReadingPlanScope(type: ReadingPlanScopeType.wholeBible),
        pace: const ReadingPlanPace(
          mode: ReadingPaceMode.chaptersPerDay,
          chaptersPerDay: 13,
        ),
        startDate: DateTime.now(),
        totalChaptersInScope: _whole,
        completedChapterKeys: const {},
        sessions: const [],
      );

  /// Dias totais no subtítulo (ex.: «Dia 3/365»), alinhado aos presets.
  static int displayTotalDays(ReadingPlan p) {
    final cap = p.pace.chaptersPerDay ?? 1;
    if (cap == 4) return 365;
    if (cap == 7) return 180;
    if (cap == 13) return 90;
    return (p.totalChaptersInScope / cap).ceil();
  }
}
