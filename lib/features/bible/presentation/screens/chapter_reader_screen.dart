import 'package:flutter/material.dart';

class ChapterReaderScreen extends StatelessWidget {
  const ChapterReaderScreen({
    super.key,
    required this.bookId,
    required this.chapter,
  });

  final String bookId;
  final int chapter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('$bookId $chapter'),
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.text_increase_rounded), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Texto bíblico',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Aqui virá o conteúdo do capítulo (API estática, CDN ou bundle licenciado). '
              'Mantenha tipografia confortável e alto contraste.',
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.65),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                OutlinedButton(
                  onPressed: chapter > 1 ? () => Navigator.of(context).pop() : null,
                  child: const Text('Cap. anterior'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Marcar lido'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
