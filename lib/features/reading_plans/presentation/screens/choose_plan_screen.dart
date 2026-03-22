import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/biblia_auth.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../domain/entities/reading_plan.dart';
import '../../domain/services/bible_reading_plan_presets.dart';

/// Tela «Escolha seu plano» — presets 1 ano, 6 meses e 90 dias (layout referência Divine).
class ChoosePlanScreen extends ConsumerStatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  ConsumerState<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends ConsumerState<ChoosePlanScreen> {
  int _selected = 0;
  bool _submitting = false;

  static final List<_PresetUi> _presets = [
    _PresetUi(
      draft: BibleReadingPlanPresets.draftOneYear(),
      description: '4 capítulos por dia — ritmo equilibrado',
      daysLabel: '365 dias',
      capLabel: '4 cap/dia',
      badge: 'Tranquilo',
      badgeColor: Color(0xFFE8F5E9),
      badgeTextColor: Color(0xFF2E7D32),
      iconBg: Color(0xFF5C6BC0),
      icon: Icons.menu_book_rounded,
    ),
    _PresetUi(
      draft: BibleReadingPlanPresets.draftSixMonths(),
      description: '7 capítulos por dia — ritmo moderado',
      daysLabel: '180 dias',
      capLabel: '7 cap/dia',
      badge: 'Moderado',
      badgeColor: Color(0xFFFFF3E0),
      badgeTextColor: Color(0xFFE65100),
      iconBg: Color(0xFFAB47BC),
      icon: Icons.bolt_rounded,
    ),
    _PresetUi(
      draft: BibleReadingPlanPresets.draftNinetyDays(),
      description: '13 capítulos por dia — ritmo intenso',
      daysLabel: '90 dias',
      capLabel: '13 cap/dia',
      badge: 'Desafiador',
      badgeColor: Color(0xFFFFEBEE),
      badgeTextColor: Color(0xFFC62828),
      iconBg: Color(0xFFFF7043),
      icon: Icons.local_fire_department_rounded,
    ),
  ];

  Future<void> _confirm() async {
    if (_submitting) return;
    final authed = ref.read(authProvider).value?.isAuthenticated ?? false;
    if (!authed) {
      if (!mounted) return;
      await context.push('/auth/login');
      return;
    }
    setState(() => _submitting = true);
    try {
      final repo = ref.read(readingPlanRepositoryProvider);
      final draft = _presets[_selected].draft;
      final created = await repo.create(draft, replaceOtherPlans: true);
      ref.invalidate(readingPlansListProvider);
      if (!mounted) return;
      context.pop();
      context.push('/home/plans/${created.id}');
    } on ApiException catch (e) {
      if (!mounted) return;
      final msg = e.statusCode == 401
          ? 'Sessão expirada. Entre de novo e confirme o plano.'
          : e.message;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível criar o plano: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(8, top + 8, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF7B1FA2),
                  Color(0xFF3949AB),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Escolha seu Plano',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        'Selecione o ritmo ideal para sua jornada bíblica',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.s16,
                AppSpacing.page,
                AppSpacing.s12,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s12),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    border: Border.all(color: scheme.primary.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('💡', style: theme.textTheme.titleMedium),
                      const SizedBox(width: AppSpacing.s8),
                      Expanded(
                        child: Text(
                          'Dica: Você pode trocar de plano a qualquer momento. Seu progresso será mantido.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.72),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),
                ...List.generate(_presets.length, (i) {
                  final p = _presets[i];
                  final sel = i == _selected;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                    child: Material(
                      color: scheme.surface,
                      elevation: sel ? 0 : 1,
                      shadowColor: Colors.black.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(AppRadii.xl),
                      child: InkWell(
                        onTap: () => setState(() => _selected = i),
                        borderRadius: BorderRadius.circular(AppRadii.xl),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.s16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadii.xl),
                            border: Border.all(
                              color: sel ? scheme.primary : scheme.outline.withValues(alpha: 0.35),
                              width: sel ? 2 : 1,
                            ),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              if (sel)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    color: scheme.primary,
                                    size: 26,
                                  ),
                                ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: p.iconBg,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(p.icon, color: Colors.white, size: 28),
                                  ),
                                  const SizedBox(width: AppSpacing.s12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.draft.title,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: AppSpacing.s6),
                                        Text(
                                          p.description,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: scheme.onSurface.withValues(alpha: 0.58),
                                            height: 1.35,
                                          ),
                                        ),
                                        const SizedBox(height: AppSpacing.s8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_outlined,
                                              size: 16,
                                              color: scheme.primary.withValues(alpha: 0.85),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              p.daysLabel,
                                              style: theme.textTheme.labelMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: scheme.onSurface.withValues(alpha: 0.65),
                                              ),
                                            ),
                                            const SizedBox(width: AppSpacing.s16),
                                            Icon(
                                              Icons.menu_book_outlined,
                                              size: 16,
                                              color: scheme.primary.withValues(alpha: 0.85),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              p.capLabel,
                                              style: theme.textTheme.labelMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: scheme.onSurface.withValues(alpha: 0.65),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: AppSpacing.s8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: p.badgeColor,
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            p.badge,
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: p.badgeTextColor,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.s8,
                AppSpacing.page,
                AppSpacing.s16,
              ),
              child: FilledButton(
                onPressed: _submitting ? null : _confirm,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: scheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                  ),
                ),
                child: _submitting
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onPrimary,
                        ),
                      )
                    : Text(
                        'Confirmar plano',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetUi {
  const _PresetUi({
    required this.draft,
    required this.description,
    required this.daysLabel,
    required this.capLabel,
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.iconBg,
    required this.icon,
  });

  final ReadingPlan draft;
  final String description;
  final String daysLabel;
  final String capLabel;
  final String badge;
  final Color badgeColor;
  final Color badgeTextColor;
  final Color iconBg;
  final IconData icon;
}
