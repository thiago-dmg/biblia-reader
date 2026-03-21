import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/icons/app_icons.dart';

/// Dock estilo “Divine”: 4 itens + **FAB central (Bíblia)** — Leitura, Oração, Estudos, SOS.
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  static const _labels = ['Leitura', 'Oração', 'Estudos', 'SOS'];

  /// 0 Leitura, 1 Oração, 2 **Bíblia (FAB)**, 3 Estudos, 4 SOS.
  static const _fabIndex = 2;
  static const _fabSize = 58.0;
  static const _fabOverhang = 24.0;

  IconData _icon(int shellIndex, bool on) {
    switch (shellIndex) {
      case 0:
        return AppLucideNav.reading(on);
      case 1:
        return AppLucideNav.prayerHeart(on);
      case 3:
        return AppLucideNav.studiesNav(on);
      case 4:
        return AppLucideNav.sosNav(on);
      default:
        return AppLucideNav.reading(on);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final br = Theme.of(context).brightness;
    final isLight = br == Brightness.light;

    final barPadBottom = AppSpacing.s8 + bottom;
    const rowMinHeight = 62.0;

    return SizedBox(
      height: _fabOverhang + AppSpacing.s8 + rowMinHeight + barPadBottom,
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isLight ? 0.08 : 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, -4),
                    ),
                    ...AppShadows.dockLift(),
                  ],
                  border: Border(
                    top: BorderSide(
                      color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.s6,
                    AppSpacing.s8,
                    AppSpacing.s6,
                    barPadBottom,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                      SizedBox(width: _fabSize + AppSpacing.s8),
                      Expanded(
                        child: _SideNavItem(
                          label: _labels[2],
                          icon: _icon(3, currentIndex == 3),
                          selected: currentIndex == 3,
                          onTap: () => onSelect(3),
                        ),
                      ),
                      Expanded(
                        child: _SideNavItem(
                          label: _labels[3],
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
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedScale(
                scale: currentIndex == _fabIndex ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                child: _CenterBibleFab(
                  selected: currentIndex == _fabIndex,
                  gradient: br == Brightness.dark
                      ? AppGradients.brandPrimaryDark
                      : AppGradients.fabBible,
                  onTap: () => onSelect(_fabIndex),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterBibleFab extends StatelessWidget {
  const _CenterBibleFab({
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
            borderRadius: BorderRadius.circular(20),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: gradient,
              boxShadow: AppShadows.fabHero(br, selected: selected),
              border: Border.all(
                color: Colors.white.withValues(alpha: selected ? 0.5 : 0.32),
                width: 1.2,
              ),
            ),
            child: Icon(
              AppLucideNav.bible(true),
              size: AppIconSizes.navActive + 2,
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
        : scheme.onSurfaceVariant.withValues(alpha: 0.72);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        splashColor: scheme.primary.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 8,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    width: selected ? 24 : 0,
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
                size: selected ? AppIconSizes.navActive + 1 : AppIconSizes.nav,
                color: fg,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.labelLarge?.copyWith(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  letterSpacing: 0.02,
                  color: fg,
                  height: 1.05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
