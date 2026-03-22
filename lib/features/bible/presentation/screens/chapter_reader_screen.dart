import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../reading_plans/domain/entities/reading_plan.dart';
import '../../../reading_plans/domain/services/canonical_bible_chapter_order.dart';
import '../providers/bible_providers.dart';

class ChapterReaderScreen extends ConsumerStatefulWidget {
  const ChapterReaderScreen({
    super.key,
    required this.bookId,
    required this.chapter,
  });

  final String bookId;
  final int chapter;

  @override
  ConsumerState<ChapterReaderScreen> createState() => _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends ConsumerState<ChapterReaderScreen> {
  bool _recordingRead = false;

  String get _key => '${widget.bookId}|${widget.chapter}';

  String get _chapterKey =>
      CanonicalBibleChapterOrder.formatChapterKey(widget.bookId, widget.chapter);

  Future<void> _markAsRead() async {
    if (_recordingRead) return;

    List<ReadingPlan> plans;
    try {
      plans = await ref.read(readingPlansListProvider.future);
    } catch (_) {
      plans = const [];
    }

    if (!mounted) return;
    if (plans.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Crie um plano de leitura na home para registrar o progresso aqui.',
          ),
        ),
      );
      return;
    }

    final planId = plans.first.id;
    setState(() => _recordingRead = true);
    try {
      await ref.read(readingPlanRepositoryProvider).addChapterReads(planId, [_chapterKey]);
      ref.invalidate(readingPlansListProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leitura registrada no seu plano.')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível registrar: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      if (mounted) setState(() => _recordingRead = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final asyncChapter = ref.watch(bibleChapterProvider(_key));
    final booksAsync = ref.watch(bibleBooksProvider);

    var maxChapter = 999;
    final list = booksAsync.valueOrNull;
    if (list != null) {
      final match = list.where((x) => x.abbreviation == widget.bookId);
      if (match.isNotEmpty) {
        maxChapter = match.first.chapterCount;
      }
    }

    final bookId = widget.bookId;
    final chapter = widget.chapter;

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
                      onPressed: _recordingRead ? null : _markAsRead,
                      child: _recordingRead
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : const Text('Marcar lido'),
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
