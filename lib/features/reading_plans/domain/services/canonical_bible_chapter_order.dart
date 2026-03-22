import '../entities/reading_plan.dart';
import '../entities/reading_plan_scope.dart';

/// Ordem protestante 66 livros → chaves `ABBREV:n` (alinhado ao backend / planos).
abstract final class CanonicalBibleChapterOrder {
  static const _books = <(String abbrev, int chapters)>[
    ('GEN', 50),
    ('EXO', 40),
    ('LEV', 27),
    ('NUM', 36),
    ('DEU', 34),
    ('JOS', 24),
    ('JDG', 21),
    ('RUT', 4),
    ('1SA', 31),
    ('2SA', 24),
    ('1KI', 22),
    ('2KI', 25),
    ('1CH', 29),
    ('2CH', 36),
    ('EZR', 10),
    ('NEH', 13),
    ('EST', 10),
    ('JOB', 42),
    ('PSA', 150),
    ('PRO', 31),
    ('ECC', 12),
    ('SNG', 8),
    ('ISA', 66),
    ('JER', 52),
    ('LAM', 5),
    ('EZK', 48),
    ('DAN', 12),
    ('HOS', 14),
    ('JOE', 3),
    ('AMO', 9),
    ('OBA', 1),
    ('JON', 4),
    ('MIC', 7),
    ('NAM', 3),
    ('HAB', 3),
    ('ZEP', 3),
    ('HAG', 2),
    ('ZEC', 14),
    ('MAL', 4),
    ('MAT', 28),
    ('MRK', 16),
    ('LUK', 24),
    ('JHN', 21),
    ('ACT', 28),
    ('ROM', 16),
    ('1CO', 16),
    ('2CO', 13),
    ('GAL', 6),
    ('EPH', 6),
    ('PHP', 4),
    ('COL', 4),
    ('1TH', 5),
    ('2TH', 3),
    ('1TI', 6),
    ('2TI', 4),
    ('TIT', 3),
    ('PHM', 1),
    ('HEB', 13),
    ('JAS', 5),
    ('1PE', 5),
    ('2PE', 3),
    ('1JN', 5),
    ('2JN', 1),
    ('3JN', 1),
    ('JUD', 1),
    ('REV', 22),
  ];

  static int get oldTestamentEndIndex => 38;

  static List<String> get wholeBibleKeys => _expandBooks(_books);

  static List<String> get oldTestamentKeys => _expandBooks(_books.sublist(0, oldTestamentEndIndex));

  static List<String> get newTestamentKeys => _expandBooks(_books.sublist(oldTestamentEndIndex));

  static List<String> keysForScope(ReadingPlanScope scope) {
    switch (scope.type) {
      case ReadingPlanScopeType.wholeBible:
        return List<String>.from(wholeBibleKeys);
      case ReadingPlanScopeType.oldTestament:
        return List<String>.from(oldTestamentKeys);
      case ReadingPlanScopeType.newTestament:
        return List<String>.from(newTestamentKeys);
      case ReadingPlanScopeType.singleBook:
        if (scope.bookIds.isEmpty) return [];
        final abbr = scope.bookIds.first.toUpperCase();
        (String, int)? row;
        for (final e in _books) {
          if (e.$1 == abbr) {
            row = e;
            break;
          }
        }
        final hit = row;
        if (hit == null) return [];
        return List.generate(hit.$2, (i) => '${hit.$1}:${i + 1}');
      case ReadingPlanScopeType.customList:
        return List<String>.from(scope.customChapterKeys);
    }
  }

  static List<String> _expandBooks(List<(String, int)> books) {
    final out = <String>[];
    for (final (abbr, n) in books) {
      for (var i = 1; i <= n; i++) {
        out.add('$abbr:$i');
      }
    }
    return out;
  }

  /// Capítulos sugeridos para hoje (próximos não lidos na ordem).
  static List<String> suggestedChapterKeysForToday(
    ReadingPlan plan, {
    required int suggestedCount,
  }) {
    if (suggestedCount <= 0) return [];
    final order = keysForScope(plan.scope);
    if (order.isEmpty) return [];

    final done = <String>{...plan.completedChapterKeys};
    if (plan.serverCompletedChapters != null &&
        plan.completedChapterKeys.isEmpty &&
        plan.serverCompletedChapters! > 0) {
      final n = plan.serverCompletedChapters!.clamp(0, order.length);
      done.addAll(order.take(n));
    }

    final pending = order.where((k) => !done.contains(k)).toList();
    return pending.take(suggestedCount).toList();
  }

  static (String book, int chapter) parseKey(String key) {
    final i = key.lastIndexOf(':');
    if (i <= 0) return ('GEN', 1);
    final b = key.substring(0, i).toUpperCase();
    final c = int.tryParse(key.substring(i + 1)) ?? 1;
    return (b, c);
  }

  /// Chave alinhada à API e ao plano (`GEN:1`, `JHN:3`…).
  static String formatChapterKey(String bookAbbrev, int chapter) =>
      '${bookAbbrev.trim().toUpperCase()}:$chapter';
}
