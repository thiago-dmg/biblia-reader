import 'package:equatable/equatable.dart';

import 'reading_plan_pace.dart';
import 'reading_plan_scope.dart';
import 'reading_session.dart';

class ReadingPlan extends Equatable {
  const ReadingPlan({
    required this.id,
    required this.title,
    required this.scope,
    required this.pace,
    required this.startDate,
    required this.totalChaptersInScope,
    required this.completedChapterKeys,
    required this.sessions,
    this.paused = false,
  });

  final String id;
  final String title;
  final ReadingPlanScope scope;
  final ReadingPlanPace pace;
  final DateTime startDate;
  final int totalChaptersInScope;
  final Set<String> completedChapterKeys;
  final List<ReadingSession> sessions;
  final bool paused;

  int get completedCount => completedChapterKeys.length;
  int get remainingChapters => (totalChaptersInScope - completedCount).clamp(0, totalChaptersInScope);

  ReadingPlan copyWith({
    String? id,
    String? title,
    ReadingPlanScope? scope,
    ReadingPlanPace? pace,
    DateTime? startDate,
    int? totalChaptersInScope,
    Set<String>? completedChapterKeys,
    List<ReadingSession>? sessions,
    bool? paused,
  }) {
    return ReadingPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      scope: scope ?? this.scope,
      pace: pace ?? this.pace,
      startDate: startDate ?? this.startDate,
      totalChaptersInScope: totalChaptersInScope ?? this.totalChaptersInScope,
      completedChapterKeys: completedChapterKeys ?? this.completedChapterKeys,
      sessions: sessions ?? this.sessions,
      paused: paused ?? this.paused,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        scope,
        pace,
        startDate,
        totalChaptersInScope,
        completedChapterKeys,
        sessions,
        paused,
      ];
}
