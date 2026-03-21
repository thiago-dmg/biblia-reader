import 'package:equatable/equatable.dart';

/// Snapshot recalculado — use sempre a partir de [ReadingPlanProgressCalculator].
class ReadingPlanProgressSnapshot extends Equatable {
  const ReadingPlanProgressSnapshot({
    required this.referenceDate,
    required this.percentComplete,
    required this.remainingChapters,
    required this.completedChapters,
    required this.totalChapters,
    required this.suggestedChaptersToday,
    required this.estimatedDaysRemaining,
    required this.effectiveTargetEnd,
    required this.isBehindSchedule,
    required this.daysElapsed,
  });

  final DateTime referenceDate;
  final double percentComplete;
  final int remainingChapters;
  final int completedChapters;
  final int totalChapters;
  /// Quota sugerida para “cumprir” o plano na data de referência.
  final int suggestedChaptersToday;
  final int estimatedDaysRemaining;
  final DateTime effectiveTargetEnd;
  final bool isBehindSchedule;
  final int daysElapsed;

  @override
  List<Object?> get props => [
        referenceDate,
        percentComplete,
        remainingChapters,
        completedChapters,
        totalChapters,
        suggestedChaptersToday,
        estimatedDaysRemaining,
        effectiveTargetEnd,
        isBehindSchedule,
        daysElapsed,
      ];
}
