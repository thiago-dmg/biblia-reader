import '../../../../core/api/api_dtos.dart';
import '../../domain/entities/reading_plan.dart';
import '../../domain/entities/reading_plan_pace.dart';
import '../../domain/entities/reading_plan_scope.dart';

ReadingPlan mapReadingPlanResponseDto(ReadingPlanResponseDto dto) {
  final scopeIdx = dto.scopeType.clamp(0, ReadingPlanScopeType.values.length - 1);
  final paceIdx = dto.paceMode.clamp(0, ReadingPaceMode.values.length - 1);

  DateTime start;
  final so = dto.startedOn.trim();
  if (so.length >= 10) {
    start = DateTime.tryParse(so.substring(0, 10)) ?? DateTime.now();
  } else {
    start = DateTime.tryParse(so) ?? DateTime.now();
  }

  DateTime? targetEnd;
  final te = dto.targetEndDate?.trim();
  if (te != null && te.length >= 10) {
    targetEnd = DateTime.tryParse(te.substring(0, 10));
  }

  return ReadingPlan(
    id: dto.id,
    title: dto.title,
    scope: ReadingPlanScope(
      type: ReadingPlanScopeType.values[scopeIdx],
    ),
    pace: ReadingPlanPace(
      mode: ReadingPaceMode.values[paceIdx],
      chaptersPerDay: dto.chaptersPerDay,
      targetEndDate: targetEnd,
      durationDays: dto.durationDays,
    ),
    startDate: start,
    totalChaptersInScope: dto.totalChapters,
    completedChapterKeys: const {},
    sessions: const [],
    paused: dto.paused,
    serverCompletedChapters: dto.completedChapters,
  );
}

CreateReadingPlanRequest domainToCreateRequest(
  ReadingPlan plan, {
  bool replaceOtherPlans = false,
}) {
  String? targetEnd;
  final t = plan.pace.targetEndDate;
  if (t != null) {
    targetEnd =
        '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
  }

  return CreateReadingPlanRequest(
    title: plan.title,
    scopeType: plan.scope.type.index,
    bookIds: plan.scope.bookIds.isEmpty ? null : List<String>.from(plan.scope.bookIds),
    paceMode: plan.pace.mode.index,
    chaptersPerDay: plan.pace.chaptersPerDay,
    targetEndDate: targetEnd,
    durationDays: plan.pace.durationDays,
    bibleVersionId: null,
    replaceOtherPlans: replaceOtherPlans,
  );
}
