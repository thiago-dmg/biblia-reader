import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudiesHomeScreen extends StatelessWidget {
  const StudiesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudos')),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
        children: [
          _StudyTile(
            title: 'Fé no dia a dia',
            category: 'Crescimento',
            onTap: () => context.push('/studies/study-1'),
          ),
          _StudyTile(
            title: 'Salmos — lamentos',
            category: 'Antigo Testamento',
            onTap: () => context.push('/studies/study-2'),
          ),
        ],
      ),
    );
  }
}

class _StudyTile extends StatelessWidget {
  const _StudyTile({
    required this.title,
    required this.category,
    required this.onTap,
  });

  final String title;
  final String category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category, style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
