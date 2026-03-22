import 'dart:convert';

import '../domain/entities/reading_plan.dart';
import '../domain/entities/reading_plan_pace.dart';
import '../domain/entities/reading_plan_scope.dart';
import '../domain/entities/reading_session.dart';

Map<String, dynamic> readingPlanToLocalJson(ReadingPlan p) {
  return {
    'id': p.id,
    'title': p.title,
    'scopeType': p.scope.type.index,
    'bookIds': p.scope.bookIds,
    'customChapterKeys': p.scope.customChapterKeys,
    'paceMode': p.pace.mode.index,
    'chaptersPerDay': p.pace.chaptersPerDay,
    'targetEndDate': p.pace.targetEndDate?.toIso8601String(),
    'durationDays': p.pace.durationDays,
    'startDate': p.startDate.toIso8601String(),
    'totalChapters': p.totalChaptersInScope,
    'completedChapterKeys': p.completedChapterKeys.toList(),
    'sessions': p.sessions.map((s) => {
          'date': DateTime(s.date.year, s.date.month, s.date.day).toIso8601String(),
          'chapterKeys': s.chapterKeys,
        }).toList(),
    'paused': p.paused,
    'serverCompletedChapters': p.serverCompletedChapters,
  };
}

ReadingPlan readingPlanFromLocalJson(Map<String, dynamic> m) {
  final scopeIdx = (m['scopeType'] as num?)?.toInt() ?? 0;
  final paceIdx = (m['paceMode'] as num?)?.toInt() ?? 0;
  final scopeType = ReadingPlanScopeType.values[scopeIdx.clamp(0, ReadingPlanScopeType.values.length - 1)];
  final paceMode = ReadingPaceMode.values[paceIdx.clamp(0, ReadingPaceMode.values.length - 1)];

  DateTime parseDate(String? s) {
    if (s == null || s.isEmpty) return DateTime.now();
    return DateTime.tryParse(s) ?? DateTime.now();
  }

  final sessionsRaw = m['sessions'];
  final sessions = <ReadingSession>[];
  if (sessionsRaw is List) {
    for (final e in sessionsRaw) {
      if (e is! Map) continue;
      final em = Map<String, dynamic>.from(e);
      final keys = em['chapterKeys'];
      sessions.add(
        ReadingSession(
          date: parseDate(em['date'] as String?),
          chapterKeys: keys is List ? keys.map((x) => '$x').toList() : const [],
        ),
      );
    }
  }

  final completedRaw = m['completedChapterKeys'];
  final completed = <String>{};
  if (completedRaw is List) {
    for (final e in completedRaw) {
      completed.add('$e');
    }
  }

  return ReadingPlan(
    id: '${m['id'] ?? ''}',
    title: '${m['title'] ?? 'Plano'}',
    scope: ReadingPlanScope(
      type: scopeType,
      bookIds: (m['bookIds'] as List?)?.map((e) => '$e').toList() ?? const [],
      customChapterKeys:
          (m['customChapterKeys'] as List?)?.map((e) => '$e').toList() ?? const [],
    ),
    pace: ReadingPlanPace(
      mode: paceMode,
      chaptersPerDay: (m['chaptersPerDay'] as num?)?.toInt(),
      targetEndDate: m['targetEndDate'] != null ? DateTime.tryParse('${m['targetEndDate']}') : null,
      durationDays: (m['durationDays'] as num?)?.toInt(),
    ),
    startDate: parseDate(m['startDate'] as String?),
    totalChaptersInScope: (m['totalChapters'] as num?)?.toInt() ?? 0,
    completedChapterKeys: completed,
    sessions: sessions,
    paused: m['paused'] as bool? ?? false,
    serverCompletedChapters: (m['serverCompletedChapters'] as num?)?.toInt(),
  );
}

String encodeReadingPlans(List<ReadingPlan> plans) =>
    jsonEncode(plans.map(readingPlanToLocalJson).toList());

List<ReadingPlan> decodeReadingPlans(String? raw) {
  if (raw == null || raw.isEmpty) return [];
  final decoded = jsonDecode(raw);
  if (decoded is! List) return [];
  return decoded
      .map((e) => readingPlanFromLocalJson(Map<String, dynamic>.from(e as Map)))
      .toList();
}
