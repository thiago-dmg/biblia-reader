import 'package:equatable/equatable.dart';

/// Escopo do plano: qual conjunto de capítulos entra na meta.
enum ReadingPlanScopeType {
  wholeBible,
  newTestament,
  oldTestament,
  singleBook,
  customList,
}

class ReadingPlanScope extends Equatable {
  const ReadingPlanScope({
    required this.type,
    this.bookIds = const [],
    this.customChapterKeys = const [],
  });

  final ReadingPlanScopeType type;
  final List<String> bookIds;
  /// Identificadores estáveis: "GEN:1", "JHN:3" etc.
  final List<String> customChapterKeys;

  @override
  List<Object?> get props => [type, bookIds, customChapterKeys];
}
