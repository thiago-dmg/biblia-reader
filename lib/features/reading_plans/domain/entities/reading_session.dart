import 'package:equatable/equatable.dart';

/// Registro de leitura (para streak e histórico). Chaves de capítulo lidos naquele dia.
class ReadingSession extends Equatable {
  const ReadingSession({
    required this.date,
    required this.chapterKeys,
  });

  final DateTime date;
  final List<String> chapterKeys;

  @override
  List<Object?> get props => [date, chapterKeys];
}
