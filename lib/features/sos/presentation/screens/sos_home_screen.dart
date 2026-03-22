import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';

/// SOS — atalho rápido (conteúdo pode ligar a linha de apoio / suporte).
class SosHomeScreen extends StatelessWidget {
  const SosHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('SOS')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          Icon(Icons.shield_outlined, size: 56, color: scheme.primary),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'Precisa de ajuda agora?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            'Em breve: contatos de apoio emocional e espiritual. '
            'Por enquanto, use o suporte no app.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: AppSpacing.s24),
          FilledButton(
            onPressed: () => context.go('/support'),
            child: const Text('Abrir suporte'),
          ),
        ],
      ),
    );
  }
}
