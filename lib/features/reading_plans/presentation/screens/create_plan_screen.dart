import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/icons/app_icons.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  double _chaptersPerDay = 4;
  String _scope = 'Bíblia inteira';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final br = theme.brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text('Novo plano', style: theme.textTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.s12,
          AppSpacing.page,
          AppSpacing.s48,
        ),
        children: [
          Text(
            'Defina o ritmo',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            'O app recalcula metas diariamente. Você pode mudar quando quiser.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.52),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          _FormSection(
            brightness: br,
            label: 'Escopo',
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _scope,
                items: const [
                  DropdownMenuItem(
                    value: 'Bíblia inteira',
                    child: Text('Bíblia inteira'),
                  ),
                  DropdownMenuItem(
                    value: 'Novo Testamento',
                    child: Text('Novo Testamento'),
                  ),
                  DropdownMenuItem(
                    value: 'Livro específico',
                    child: Text('Livro específico'),
                  ),
                ],
                onChanged: (v) => setState(() => _scope = v ?? _scope),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s18),
          _FormSection(
            brightness: br,
            label: 'Capítulos por dia',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Intensidade',
                      style: theme.textTheme.titleMedium,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s12,
                        vertical: AppSpacing.s6,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                      ),
                      child: Text(
                        '${_chaptersPerDay.toInt()}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _chaptersPerDay,
                  min: 1,
                  max: 12,
                  divisions: 11,
                  onChanged: (v) => setState(() => _chaptersPerDay = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  content: const Text(
                    'POST /v1/reading-plans (integração futura)',
                  ),
                ),
              );
            },
            icon: const Icon(AppLucideUi.check, size: 20),
            label: const Text('Criar plano'),
          ),
        ],
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.label,
    required this.child,
    required this.brightness,
  });

  final String label;
  final Widget child;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.7)),
        boxShadow: AppShadows.card(brightness),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.s12),
            child,
          ],
        ),
      ),
    );
  }
}
