import 'package:equatable/equatable.dart';

/// Como o ritmo da leitura é definido (dinâmico: recalcula com o tempo).
enum ReadingPaceMode {
  /// N capítulos fixos por dia; data fim deriva do que falta.
  chaptersPerDay,
  /// Terminar todo o escopo até [targetEndDate]; capítulos/dia = restante / dias úteis.
  finishByDate,
  /// Duração em dias a partir de [startDate]; mesma lógica que finishByDate com fim = start + duration.
  durationDays,
}

class ReadingPlanPace extends Equatable {
  const ReadingPlanPace({
    required this.mode,
    this.chaptersPerDay,
    this.targetEndDate,
    this.durationDays,
  });

  final ReadingPaceMode mode;
  final int? chaptersPerDay;
  final DateTime? targetEndDate;
  final int? durationDays;

  @override
  List<Object?> get props => [mode, chaptersPerDay, targetEndDate, durationDays];
}
