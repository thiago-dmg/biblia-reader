import 'reading_plan_remote_datasource.dart';

class ReadingPlanRemoteDataSourceImpl implements ReadingPlanRemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> fetchPlans() async => [];

  @override
  Future<Map<String, dynamic>> fetchPlan(String id) async => {'id': id};
}
