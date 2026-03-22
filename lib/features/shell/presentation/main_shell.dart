import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/biblia_auth.dart';
import 'app_bottom_bar.dart';

/// Branch 3 = Comunidade. Sem login, pedimos autenticação antes de trocar de aba.
class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, WidgetRef ref, int index) {
    const communityBranchIndex = 3;
    if (index == communityBranchIndex) {
      final authed = ref.read(authProvider).valueOrNull?.isAuthenticated ?? false;
      if (!authed) {
        context.push('/auth/login');
        return;
      }
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: AppBottomBar(
        currentIndex: navigationShell.currentIndex,
        onSelect: (i) => _onTap(context, ref, i),
      ),
    );
  }
}
