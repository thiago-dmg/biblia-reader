import '../../../../core/network/api_exception.dart';
import '../../../../core/api/biblia_reader_api.dart';
import '../../domain/entities/reading_plan.dart';
import '../../domain/repositories/reading_plan_repository.dart';
import '../mappers/reading_plan_api_mapper.dart';

class ReadingPlanRepositoryImpl implements ReadingPlanRepository {
  ReadingPlanRepositoryImpl({
    required BibliaReaderApi api,
    required this.getAccessToken,
  }) : _api = api;

  final BibliaReaderApi _api;
  final String? Function() getAccessToken;

  bool get _authed => (getAccessToken()?.isNotEmpty ?? false);

  @override
  Future<List<ReadingPlan>> listPlans() async {
    if (!_authed) {
      return const [];
    }
    try {
      final list = await _api.listReadingPlans();
      return list.map(mapReadingPlanResponseDto).toList();
    } on ApiException {
      return const [];
    }
  }

  @override
  Future<ReadingPlan?> getById(String id) async {
    if (!_authed) {
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
  Future<ReadingPlan> create(ReadingPlan draft) async {
    if (!_authed) {
      return draft;
    }
    final dto = await _api.createReadingPlan(domainToCreateRequest(draft));
    return mapReadingPlanResponseDto(dto);
  }

  @override
  Future<ReadingPlan> update(ReadingPlan plan) async {
    return plan;
  }

  @override
  Future<void> delete(String id) async {}
}
