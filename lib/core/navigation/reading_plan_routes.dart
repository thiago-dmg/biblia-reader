import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/biblia_auth.dart';

/// Plano na API exige conta. Convidado é redirecionado ao login.
Future<void> openChoosePlanScreen(BuildContext context, WidgetRef ref) async {
  final s = ref.read(authProvider).valueOrNull;
  if (s == null || !s.isAuthenticated) {
    await context.push('/auth/login');
    return;
  }
  if (context.mounted) {
    context.push('/home/plans/pick');
  }
}
