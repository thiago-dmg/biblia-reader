import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metas')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Metas diárias, semanais e por livro — sincronizadas com o backend.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          ...List.generate(
            3,
            (i) => Card(
              child: ListTile(
                title: Text('Meta ${i + 1} (exemplo)'),
                subtitle: const Text('Streak · prazo · capítulos/dia'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
