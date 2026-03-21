import '../../domain/entities/reading_plan.dart';
import '../../domain/entities/reading_plan_pace.dart';
import '../../domain/entities/reading_plan_scope.dart';
import '../../domain/repositories/reading_plan_repository.dart';
import '../datasources/reading_plan_local_datasource.dart';
import '../datasources/reading_plan_remote_datasource.dart';

/// Implementação placeholder: retorna um plano demo até existir API.
class ReadingPlanRepositoryImpl implements ReadingPlanRepository {
  ReadingPlanRepositoryImpl({
    required ReadingPlanRemoteDataSource remote,
    required ReadingPlanLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final ReadingPlanRemoteDataSource _remote;
  final ReadingPlanLocalDataSource _local; // reservado para cache offline

  static ReadingPlan _demo() {
    final start = DateTime.now().subtract(const Duration(days: 5));
    return ReadingPlan(
      id: 'demo-1',
      title: 'Bíblia em 1 ano (demo)',
      scope: const ReadingPlanScope(type: ReadingPlanScopeType.wholeBible),
      pace: ReadingPlanPace(
        mode: ReadingPaceMode.finishByDate,
        targetEndDate: DateTime.now().add(const Duration(days: 360)),
      ),
      startDate: start,
      totalChaptersInScope: 1189,
      completedChapterKeys: {'GEN:1', 'GEN:2', 'EXO:1'},
      sessions: const [],
    );
  }

  @override
  Future<List<ReadingPlan>> listPlans() async {
    try {
      await _remote.fetchPlans();
      await _local.cachedPlans();
    } catch (_) {}
    return [_demo()];
  }

  @override
  Future<ReadingPlan?> getById(String id) async => id == 'demo-1' ? _demo() : null;

  @override
  Future<ReadingPlan> create(ReadingPlan draft) async => draft;

  @override
  Future<ReadingPlan> update(ReadingPlan plan) async => plan;

  @override
  Future<void> delete(String id) async {}
}
