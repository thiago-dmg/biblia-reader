import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_dtos.dart';
import '../api/biblia_reader_api.dart';
import '../config/api_config.dart';
import '../network/biblia_http_client.dart';

class AuthState {
  const AuthState({
    required this.accessToken,
    required this.userId,
    required this.displayName,
  });

  const AuthState.unauthenticated()
      : accessToken = '',
        userId = '',
        displayName = '';

  final String accessToken;
  final String userId;
  final String displayName;

  bool get isAuthenticated => accessToken.isNotEmpty;
}

final authProvider = AsyncNotifierProvider<BibliaAuthNotifier, AuthState>(() => BibliaAuthNotifier());

/// Notifica o [GoRouter] quando login/logout altera o estado de autenticação.
class GoRouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final authNavigationRefreshProvider = Provider<GoRouterRefreshNotifier>((ref) {
  final notifier = GoRouterRefreshNotifier();
  ref.onDispose(notifier.dispose);
  ref.listen<AsyncValue<AuthState>>(authProvider, (_, value) => notifier.refresh());
  return notifier;
});

final bibliaHttpClientProvider = Provider<BibliaHttpClient>((ref) {
  return BibliaHttpClient(
    baseUrl: ApiConfig.baseUrl,
    getToken: () => ref.read(authProvider).valueOrNull?.accessToken,
  );
});

final bibliaReaderApiProvider = Provider<BibliaReaderApi>((ref) {
  return BibliaReaderApi(ref.watch(bibliaHttpClientProvider));
});

/// Progresso canônico (`/v1/me/reading-progress`); `null` se não autenticado ou erro.
final canonicalReadingProgressProvider = FutureProvider<ReadingProgressDto?>((ref) async {
  final t = ref.watch(authProvider).valueOrNull?.accessToken;
  if (t == null || t.isEmpty) return null;
  final api = ref.read(bibliaReaderApiProvider);
  return api.getReadingProgress();
});

class BibliaAuthNotifier extends AsyncNotifier<AuthState> {
  static const _kToken = 'biblia_reader_access_token';
  static const _kUserId = 'biblia_reader_user_id';
  static const _kDisplayName = 'biblia_reader_display_name';

  @override
  Future<AuthState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_kToken);
    if (token == null || token.isEmpty) {
      return const AuthState.unauthenticated();
    }
    return AuthState(
      accessToken: token,
      userId: prefs.getString(_kUserId) ?? '',
      displayName: prefs.getString(_kDisplayName) ?? '',
    );
  }

  Future<void> _persist(TokenResponse tr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, tr.accessToken);
    await prefs.setString(_kUserId, tr.userId);
    await prefs.setString(_kDisplayName, tr.displayName);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api = ref.read(bibliaReaderApiProvider);
      final tr = await api.login(LoginRequest(email: email, password: password));
      await _persist(tr);
      return AuthState(
        accessToken: tr.accessToken,
        userId: tr.userId,
        displayName: tr.displayName,
      );
    });
  }

  Future<void> register(String email, String password, String displayName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api = ref.read(bibliaReaderApiProvider);
      final tr = await api.register(
        RegisterRequest(email: email, password: password, displayName: displayName),
      );
      await _persist(tr);
      return AuthState(
        accessToken: tr.accessToken,
        userId: tr.userId,
        displayName: tr.displayName,
      );
    });
  }

  Future<void> logout() async {
    final cur = state.valueOrNull;
    if (cur != null && cur.isAuthenticated) {
      try {
        await ref.read(bibliaReaderApiProvider).logout();
      } catch (_) {}
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kUserId);
    await prefs.remove(_kDisplayName);
    state = const AsyncData(AuthState.unauthenticated());
  }
}
