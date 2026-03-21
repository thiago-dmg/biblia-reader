import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Aparência', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tema',
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ThemeMode>(
                isExpanded: true,
                value: mode,
                items: const [
                  DropdownMenuItem(value: ThemeMode.system, child: Text('Sistema')),
                  DropdownMenuItem(value: ThemeMode.light, child: Text('Claro')),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text('Escuro')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    ref.read(themeModeProvider.notifier).state = v;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
