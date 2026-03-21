import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/icons/app_icons.dart';

/// Dock com **FAB central** (Planos): gradiente da marca, demais itens com indicador refinado.
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  static const _labels = ['Início', 'Bíblia', 'Planos', 'Comunidade', 'Perfil'];

  static const _fabIndex = 2;
  static const _fabSize = 56.0;
  static const _fabOverhang = 26.0;

  IconData _icon(int i, bool on) {
    switch (i) {
      case 0:
        return AppLucideNav.home(on);
      case 1:
        return AppLucideNav.bible(on);
      case 2:
        return AppLucideNav.plans(on);
      case 3:
        return AppLucideNav.community(on);
      case 4:
        return AppLucideNav.profile(on);
      default:
        return AppLucideNav.home(on);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final br = Theme.of(context).brightness;
    final isLight = br == Brightness.light;

    final barPadBottom = AppSpacing.s8 + bottom;
    // Área mínima do conteúdo: traço (9) + ícone (até 24) + gap (6) + label (~11) ≈ 58.
    const rowMinHeight = 58.0;

    return SizedBox(
      height: _fabOverhang + AppSpacing.s12 + rowMinHeight + barPadBottom,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: _fabOverhang,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadii.sheet),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  boxShadow: AppShadows.dockLift(),
                  border: Border(
                    top: BorderSide(
                      color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
                      width: 1,
                    ),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.s8,
                  AppSpacing.s12,
                  AppSpacing.s8,
                  barPadBottom,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _SideNavItem(
                        label: _labels[0],
                        icon: _icon(0, currentIndex == 0),
                        selected: currentIndex == 0,
                        onTap: () => onSelect(0),
                      ),
                    ),
                    Expanded(
                      child: _SideNavItem(
                        label: _labels[1],
                        icon: _icon(1, currentIndex == 1),
                        selected: currentIndex == 1,
                        onTap: () => onSelect(1),
                      ),
                    ),
                    const SizedBox(width: _fabSize + AppSpacing.s8),
                    Expanded(
                      child: _SideNavItem(
                        label: _labels[3],
                        icon: _icon(3, currentIndex == 3),
                        selected: currentIndex == 3,
                        onTap: () => onSelect(3),
                      ),
                    ),
                    Expanded(
                      child: _SideNavItem(
                        label: _labels[4],
                        icon: _icon(4, currentIndex == 4),
                        selected: currentIndex == 4,
                        onTap: () => onSelect(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: _CenterPlanFab(
                selected: currentIndex == _fabIndex,
                gradient: br == Brightness.dark
                    ? AppGradients.brandPrimaryDark
                    : AppGradients.brandPrimary,
                onTap: () => onSelect(_fabIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterPlanFab extends StatelessWidget {
  const _CenterPlanFab({
    required this.selected,
    required this.gradient,
    required this.onTap,
  });

  final bool selected;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final br = Theme.of(context).brightness;

    return SizedBox(
      width: AppBottomBar._fabSize,
      height: AppBottomBar._fabSize,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: gradient,
              boxShadow: AppShadows.fabHero(br, selected: selected),
              border: Border.all(
                color: Colors.white.withValues(alpha: selected ? 0.42 : 0.28),
                width: 1,
              ),
            ),
            child: Icon(
              AppLucideNav.plans(true),
              size: AppIconSizes.navActive + 1,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final fg = selected
        ? scheme.primary
        : scheme.onSurfaceVariant.withValues(alpha: 0.78);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.md),
      splashColor: scheme.primary.withValues(alpha: 0.08),
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 9,
              child: Align(
                alignment: Alignment.topCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: selected ? 22 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: selected
                        ? LinearGradient(
                            colors: [
                              scheme.primary,
                              scheme.secondary,
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Icon(
              icon,
              size: selected ? AppIconSizes.navActive : AppIconSizes.nav,
              color: fg,
            ),
            const SizedBox(height: AppSpacing.s6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelLarge?.copyWith(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: 0.1,
                color: fg,
                height: 1.05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
