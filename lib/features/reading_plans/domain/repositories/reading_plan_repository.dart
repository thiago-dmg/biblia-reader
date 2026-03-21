import '../entities/reading_plan.dart';

/// Contrato para persistência remota/local — implementação em [data].
abstract class ReadingPlanRepository {
  Future<List<ReadingPlan>> listPlans();
  Future<ReadingPlan?> getById(String id);
  Future<ReadingPlan> create(ReadingPlan draft);
  Future<ReadingPlan> update(ReadingPlan plan);
  Future<void> delete(String id);
}
