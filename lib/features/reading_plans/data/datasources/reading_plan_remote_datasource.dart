/// Chamadas HTTP futuras: GET/POST /v1/reading-plans
abstract class ReadingPlanRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchPlans();
  Future<Map<String, dynamic>> fetchPlan(String id);
}
