import '../entities/reading_plan.dart';

/// Contrato para persistência remota/local — implementação em [data].
abstract class ReadingPlanRepository {
  Future<List<ReadingPlan>> listPlans();
  Future<ReadingPlan?> getById(String id);
  /// [replaceOtherPlans]: na API, remove outros planos do usuário antes de criar (fluxo «Escolha seu plano»).
  Future<ReadingPlan> create(ReadingPlan draft, {bool replaceOtherPlans = false});
  Future<ReadingPlan> update(ReadingPlan plan);
  Future<void> delete(String id);

  /// Sem autenticação: apaga planos guardados localmente (ex.: antes de escolher um novo preset).
  Future<void> clearGuestPlans();

  /// Registra capítulos lidos no plano (`POST /v1/reading-plans/{id}/events` ou armazenamento local).
  Future<void> addChapterReads(String planId, List<String> chapterKeys);
}
