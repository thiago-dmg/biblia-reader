import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../providers/bible_providers.dart';

class ChapterReaderScreen extends ConsumerWidget {
  const ChapterReaderScreen({
    super.key,
    required this.bookId,
    required this.chapter,
  });

  final String bookId;
  final int chapter;

  String get _key => '$bookId|$chapter';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final asyncChapter = ref.watch(bibleChapterProvider(_key));
    final booksAsync = ref.watch(bibleBooksProvider);

    var maxChapter = 999;
    final list = booksAsync.valueOrNull;
    if (list != null) {
      final match = list.where((x) => x.abbreviation == bookId);
      if (match.isNotEmpty) {
        maxChapter = match.first.chapterCount;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: asyncChapter.maybeWhen(
          data: (d) => Text('${d.bookName} $chapter · ${d.versionCode.toUpperCase()}'),
          orElse: () => Text('$bookId $chapter'),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.text_increase_rounded), onPressed: () {}),
        ],
      ),
      body: asyncChapter.when(
        data: (dto) {
          final html = dto.contentHtml;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (html != null && html.isNotEmpty)
                  Html(
                    data: html,
                    style: {
                      'body': Style(
                        margin: Margins.zero,
                        fontSize: FontSize(18),
                        lineHeight: const LineHeight(1.65),
                        color: scheme.onSurface,
                      ),
                      'p': Style(
                        margin: Margins.only(bottom: 12),
                      ),
                    },
                  )
                else
                  Text(
                    'Este capítulo ainda não tem texto no servidor. '
                    'Não foi possível carregar o capítulo. Verifique a conexão e se a API está servindo a ACF (veja docs/BIBLE_EXTERNAL_API.md).',
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.65),
                  ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: chapter <= 1
                          ? null
                          : () => context.go('/bible/read/$bookId/${chapter - 1}'),
                      child: const Text('Anterior'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () {},
                      child: const Text('Marcar lido'),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: chapter >= maxChapter
                          ? null
                          : () => context.go('/bible/read/$bookId/${chapter + 1}'),
                      child: const Text('Próximo'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: Text(
              'Erro ao carregar capítulo.\n$e',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
