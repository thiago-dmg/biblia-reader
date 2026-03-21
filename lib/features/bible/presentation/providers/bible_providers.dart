import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_dtos.dart';
import '../../../../core/auth/biblia_auth.dart';

/// Livros — padrão **ACF** na API (Almeida Corrigida Fiel via provedor externo).
final bibleBooksProvider = FutureProvider<List<BibleBookRowDto>>((ref) async {
  final api = ref.watch(bibliaReaderApiProvider);
  return api.bibleBooks(versionCode: 'acf');
});

final bibleChapterProvider =
    FutureProvider.autoDispose.family<BibleChapterContentDto, String>((ref, key) async {
  final parts = key.split('|');
  if (parts.length != 2) {
    throw ArgumentError('Chave inválida: $key');
  }
  final abbr = parts[0];
  final ch = int.tryParse(parts[1]) ?? 1;
  final api = ref.read(bibliaReaderApiProvider);
  return api.bibleChapter(bookAbbrev: abbr, number: ch, versionCode: 'acf');
});
