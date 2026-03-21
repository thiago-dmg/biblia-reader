import 'package:biblia_reader/features/reading_plans/domain/entities/reading_plan.dart';
import 'package:biblia_reader/features/reading_plans/domain/entities/reading_plan_pace.dart';
import 'package:biblia_reader/features/reading_plans/domain/entities/reading_plan_scope.dart';
import 'package:biblia_reader/features/reading_plans/domain/services/reading_plan_progress_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final calc = ReadingPlanProgressCalculator();
  final start = DateTime(2025, 1, 1);
  final target = DateTime(2025, 2, 1);

  test('finishByDate sugere capítulos por dia com base no restante', () {
    final plan = ReadingPlan(
      id: 'p1',
      title: 'Teste',
      scope: const ReadingPlanScope(type: ReadingPlanScopeType.wholeBible),
      pace: ReadingPlanPace(
        mode: ReadingPaceMode.finishByDate,
        targetEndDate: target,
      ),
      startDate: start,
      totalChaptersInScope: 30,
      completedChapterKeys: const {},
      sessions: const [],
    );
    final snap = calc.compute(plan, referenceDate: DateTime(2025, 1, 15));
    expect(snap.remainingChapters, 30);
    expect(snap.suggestedChaptersToday, greaterThan(0));
    expect(snap.percentComplete, 0);
  });

  test('chaptersPerDay respeita ritmo fixo', () {
    final plan = ReadingPlan(
      id: 'p2',
      title: '4 por dia',
      scope: const ReadingPlanScope(type: ReadingPlanScopeType.wholeBible),
      pace: const ReadingPlanPace(
        mode: ReadingPaceMode.chaptersPerDay,
        chaptersPerDay: 4,
      ),
      startDate: start,
      totalChaptersInScope: 100,
      completedChapterKeys: const {},
      sessions: const [],
    );
    final snap = calc.compute(plan, referenceDate: DateTime(2025, 1, 10));
    expect(snap.suggestedChaptersToday, 4);
  });

  test('markChaptersRead adiciona capítulos', () {
    final plan = ReadingPlan(
      id: 'p3',
      title: 'X',
      scope: const ReadingPlanScope(type: ReadingPlanScopeType.wholeBible),
      pace: const ReadingPlanPace(mode: ReadingPaceMode.chaptersPerDay, chaptersPerDay: 1),
      startDate: start,
      totalChaptersInScope: 10,
      completedChapterKeys: const {},
      sessions: const [],
    );
    final updated = calc.markChaptersRead(plan, ['GEN:1'], DateTime(2025, 1, 5));
    expect(updated.completedCount, 1);
  });
}
