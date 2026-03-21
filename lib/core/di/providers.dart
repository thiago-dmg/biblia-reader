import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/reading_plans/data/datasources/reading_plan_local_datasource_impl.dart';
import '../../features/reading_plans/data/datasources/reading_plan_remote_datasource_impl.dart';
import '../../features/reading_plans/data/repositories/reading_plan_repository_impl.dart';
import '../../features/reading_plans/domain/entities/reading_plan.dart';
import '../../features/reading_plans/domain/repositories/reading_plan_repository.dart';

final readingPlanRepositoryProvider = Provider<ReadingPlanRepository>((ref) {
  return ReadingPlanRepositoryImpl(
    remote: ReadingPlanRemoteDataSourceImpl(),
    local: ReadingPlanLocalDataSourceImpl(),
  );
});

final readingPlansListProvider = FutureProvider<List<ReadingPlan>>((ref) {
  return ref.watch(readingPlanRepositoryProvider).listPlans();
});
