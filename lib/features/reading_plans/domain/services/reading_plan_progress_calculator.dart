import '../entities/reading_plan.dart';
import '../entities/reading_plan_pace.dart';
import '../entities/reading_plan_progress_snapshot.dart';
import '../entities/reading_session.dart';

/// Motor de plano dinâmico: recalcula metas diárias conforme atraso, pausa e modo de ritmo.
class ReadingPlanProgressCalculator {
  const ReadingPlanProgressCalculator();

  ReadingPlanProgressSnapshot compute(
    ReadingPlan plan, {
    required DateTime referenceDate,
  }) {
    if (plan.paused || plan.totalChaptersInScope <= 0) {
      return ReadingPlanProgressSnapshot(
        referenceDate: _dateOnly(referenceDate),
        percentComplete: plan.totalChaptersInScope <= 0 ? 1 : plan.completedCount / plan.totalChaptersInScope,
        remainingChapters: plan.remainingChapters,
        completedChapters: plan.completedCount,
        totalChapters: plan.totalChaptersInScope,
        suggestedChaptersToday: 0,
        estimatedDaysRemaining: 0,
        effectiveTargetEnd: _dateOnly(referenceDate),
        isBehindSchedule: false,
        daysElapsed: _daysBetween(_dateOnly(plan.startDate), _dateOnly(referenceDate)),
      );
    }

    final today = _dateOnly(referenceDate);
    final start = _dateOnly(plan.startDate);
    final remaining = plan.remainingChapters;
    final completed = plan.completedCount;
    final total = plan.totalChaptersInScope;
    final pct = completed / total;

    DateTime targetEnd;
    switch (plan.pace.mode) {
      case ReadingPaceMode.chaptersPerDay:
        final perDay = (plan.pace.chaptersPerDay ?? 1).clamp(1, 999);
        final daysNeeded = (remaining / perDay).ceil();
        targetEnd = today.add(Duration(days: daysNeeded));
        break;
      case ReadingPaceMode.finishByDate:
        targetEnd = _dateOnly(plan.pace.targetEndDate ?? today);
        if (targetEnd.isBefore(today)) targetEnd = today;
        break;
      case ReadingPaceMode.durationDays:
        final d = plan.pace.durationDays ?? 1;
        targetEnd = start.add(Duration(days: d));
        break;
    }

    final daysLeftInclusive = _daysBetween(today, targetEnd) + 1;
    int suggestedToday;
    if (plan.pace.mode == ReadingPaceMode.chaptersPerDay) {
      suggestedToday = (plan.pace.chaptersPerDay ?? 1).clamp(1, 999);
    } else {
      suggestedToday = daysLeftInclusive <= 0
          ? remaining
          : (remaining / daysLeftInclusive).ceil().clamp(1, remaining);
    }

    final idealProgressByToday = _idealProgressFraction(plan, today, targetEnd, total);
    final isBehind = pct + 1e-6 < idealProgressByToday && remaining > 0;

    final estDays = plan.pace.mode == ReadingPaceMode.chaptersPerDay
        ? (remaining / (plan.pace.chaptersPerDay ?? 1)).ceil()
        : (daysLeftInclusive - 1).clamp(0, 99999);

    return ReadingPlanProgressSnapshot(
      referenceDate: today,
      percentComplete: pct,
      remainingChapters: remaining,
      completedChapters: completed,
      totalChapters: total,
      suggestedChaptersToday: suggestedToday,
      estimatedDaysRemaining: estDays,
      effectiveTargetEnd: targetEnd,
      isBehindSchedule: isBehind,
      daysElapsed: _daysBetween(start, today),
    );
  }

  /// Atualiza plano ao marcar capítulos lidos hoje.
  ReadingPlan markChaptersRead(
    ReadingPlan plan,
    List<String> chapterKeys,
    DateTime onDate,
  ) {
    final day = _dateOnly(onDate);
    final updated = Set<String>.from(plan.completedChapterKeys)..addAll(chapterKeys);
    final sessions = List<ReadingSession>.from(plan.sessions);
    final idx = sessions.indexWhere((s) => _dateOnly(s.date) == day);
    if (idx >= 0) {
      final merged = {...sessions[idx].chapterKeys, ...chapterKeys}.toList();
      sessions[idx] = ReadingSession(date: day, chapterKeys: merged);
    } else {
      sessions.add(ReadingSession(date: day, chapterKeys: chapterKeys));
    }
    return plan.copyWith(
      completedChapterKeys: updated,
      sessions: sessions,
    );
  }

  int currentStreak(List<ReadingSession> sessions, DateTime referenceDate) {
    if (sessions.isEmpty) return 0;
    final daysWithRead = sessions
        .where((s) => s.chapterKeys.isNotEmpty)
        .map((s) => _dateOnly(s.date))
        .toSet()
      ..removeWhere((d) => d.isAfter(_dateOnly(referenceDate)));

    var streak = 0;
    var cursor = _dateOnly(referenceDate);
    while (daysWithRead.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  double _idealProgressFraction(
    ReadingPlan plan,
    DateTime today,
    DateTime targetEnd,
    int total,
  ) {
    final start = _dateOnly(plan.startDate);
    final end = targetEnd.isBefore(start) ? start : targetEnd;
    final totalDays = _daysBetween(start, end) + 1;
    if (totalDays <= 0) return 1;
    final passed = _daysBetween(start, today) + 1;
    final clamped = passed.clamp(0, totalDays);
    return clamped / totalDays;
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static int _daysBetween(DateTime a, DateTime b) {
    final aa = DateTime(a.year, a.month, a.day);
    final bb = DateTime(b.year, b.month, b.day);
    return bb.difference(aa).inDays;
  }
}
