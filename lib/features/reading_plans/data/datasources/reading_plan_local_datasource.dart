/// Cache offline (Hive/Isar/SQLite) — stub.
abstract class ReadingPlanLocalDataSource {
  Future<List<Map<String, dynamic>>> cachedPlans();
  Future<void> savePlans(List<Map<String, dynamic>> raw);
}
