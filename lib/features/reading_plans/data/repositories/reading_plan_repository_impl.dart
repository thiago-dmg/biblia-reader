import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/api/api_dtos.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/api/biblia_reader_api.dart';
import '../../domain/entities/reading_plan.dart';
import '../../domain/repositories/reading_plan_repository.dart';
import '../../domain/services/reading_plan_progress_calculator.dart';
import '../mappers/reading_plan_api_mapper.dart';
import '../reading_plan_local_json.dart';

class ReadingPlanRepositoryImpl implements ReadingPlanRepository {
  ReadingPlanRepositoryImpl({
    required BibliaReaderApi api,
    required this.getAccessToken,
  }) : _api = api;

  static const _localKey = 'reading_plans_local_v1';

  final BibliaReaderApi _api;
  final String? Function() getAccessToken;

  bool get _authed => (getAccessToken()?.isNotEmpty ?? false);

  Future<List<ReadingPlan>> _listLocal() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_localKey);
    final list = decodeReadingPlans(raw);
    list.sort((a, b) => b.startDate.compareTo(a.startDate));
    return list;
  }

  Future<void> _saveLocal(List<ReadingPlan> plans) async {
    final p = await SharedPreferences.getInstance();
    if (plans.isEmpty) {
      await p.remove(_localKey);
      return;
    }
    await p.setString(_localKey, encodeReadingPlans(plans));
  }

  @override
  Future<void> clearGuestPlans() async {
    if (_authed) return;
    await _saveLocal([]);
  }

  @override
  Future<List<ReadingPlan>> listPlans() async {
    if (!_authed) {
      return _listLocal();
    }
    try {
      final list = await _api.listReadingPlans();
      final mapped = list.map(mapReadingPlanResponseDto).toList();
      mapped.sort((a, b) => b.startDate.compareTo(a.startDate));
      return mapped;
    } on ApiException {
      return const [];
    }
  }

  @override
  Future<ReadingPlan?> getById(String id) async {
    if (!_authed) {
      final list = await _listLocal();
      for (final plan in list) {
        if (plan.id == id) return plan;
      }
      return null;
    }
    try {
      final dto = await _api.getReadingPlan(id);
      return mapReadingPlanResponseDto(dto);
    } on ApiException {
      return null;
    }
  }

  @override
  Future<ReadingPlan> create(ReadingPlan draft, {bool replaceOtherPlans = false}) async {
    if (!_authed) {
      final id = 'local_${DateTime.now().millisecondsSinceEpoch}';
      final plan = draft.copyWith(id: id);
      final current = await _listLocal();
      await _saveLocal([plan, ...current]);
      return plan;
    }
    final dto = await _api.createReadingPlan(
      domainToCreateRequest(draft, replaceOtherPlans: replaceOtherPlans),
    );
    return mapReadingPlanResponseDto(dto);
  }

  @override
  Future<ReadingPlan> update(ReadingPlan plan) async {
    if (!_authed) {
      final list = await _listLocal();
      final idx = list.indexWhere((e) => e.id == plan.id);
      if (idx >= 0) {
        list[idx] = plan;
        await _saveLocal(list);
      }
      return plan;
    }
    return plan;
  }

  @override
  Future<void> delete(String id) async {
    if (!_authed) {
      final list = await _listLocal();
      await _saveLocal(list.where((e) => e.id != id).toList());
    }
  }

  static List<String> _normalizeChapterKeys(Iterable<String> keys) {
    return keys
        .map((k) {
          final t = k.trim();
          final i = t.lastIndexOf(':');
          if (i <= 0) return t.toUpperCase();
          return '${t.substring(0, i).toUpperCase()}:${t.substring(i + 1)}';
        })
        .where((k) => k.isNotEmpty)
        .toList();
  }

  @override
  Future<void> addChapterReads(String planId, List<String> chapterKeys) async {
    final keys = _normalizeChapterKeys(chapterKeys);
    if (keys.isEmpty) return;

    if (!_authed) {
      final plan = await getById(planId);
      if (plan == null) return;
      const calc = ReadingPlanProgressCalculator();
      final updated = calc.markChaptersRead(plan, keys, DateTime.now());
      await update(updated.copyWith(serverCompletedChapters: null));
      return;
    }

    await _api.addReadingEvents(
      planId,
      AddReadingEventsRequest(
        occurredAt: DateTime.now().toUtc(),
        chapterKeys: keys,
      ),
    );
  }
}
