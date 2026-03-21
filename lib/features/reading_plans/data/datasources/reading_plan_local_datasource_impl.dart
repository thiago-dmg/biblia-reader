import 'reading_plan_local_datasource.dart';

class ReadingPlanLocalDataSourceImpl implements ReadingPlanLocalDataSource {
  @override
  Future<List<Map<String, dynamic>>> cachedPlans() async => [];

  @override
  Future<void> savePlans(List<Map<String, dynamic>> raw) async {}
}
