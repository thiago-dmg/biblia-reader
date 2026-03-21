import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/biblia_auth.dart';
import '../../features/reading_plans/data/repositories/reading_plan_repository_impl.dart';
import '../../features/reading_plans/domain/entities/reading_plan.dart';
import '../../features/reading_plans/domain/repositories/reading_plan_repository.dart';

final readingPlanRepositoryProvider = Provider<ReadingPlanRepository>((ref) {
  return ReadingPlanRepositoryImpl(
    api: ref.watch(bibliaReaderApiProvider),
    getAccessToken: () => ref.watch(authProvider).valueOrNull?.accessToken,
  );
});

final readingPlansListProvider = FutureProvider<List<ReadingPlan>>((ref) {
  return ref.watch(readingPlanRepositoryProvider).listPlans();
});
