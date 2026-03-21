import 'package:flutter/material.dart';

class StudyDetailScreen extends StatelessWidget {
  const StudyDetailScreen({super.key, required this.studyId});

  final String studyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Estudo $studyId')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conteúdo estruturado em lições, com progresso e favoritos.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () {},
              child: const Text('Marcar como concluído'),
            ),
          ],
        ),
      ),
    );
  }
}
