import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/biblia_auth.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/bible/presentation/screens/bible_home_screen.dart';
import '../../features/bible/presentation/screens/chapter_reader_screen.dart';
import '../../features/community/presentation/screens/community_feed_screen.dart';
import '../../features/community/presentation/screens/community_post_detail_screen.dart';
import '../../features/goals/presentation/screens/goals_screen.dart';
import '../../features/home/presentation/screens/dashboard_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/prayer/presentation/screens/prayer_room_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/reading_plans/presentation/screens/create_plan_screen.dart';
import '../../features/reading_plans/presentation/screens/plan_detail_screen.dart';
import '../../features/reading_plans/presentation/screens/plans_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shell/presentation/main_shell.dart';
import '../../features/sos/presentation/screens/sos_home_screen.dart';
import '../../features/studies/presentation/screens/studies_home_screen.dart';
import '../../features/studies/presentation/screens/study_detail_screen.dart';
import '../../features/support/presentation/screens/support_home_screen.dart';
import '../config/onboarding_prefs.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRefresh = ref.watch(authNavigationRefreshProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authRefresh,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final authAsync = ref.read(authProvider);
      if (authAsync.isLoading) return null;
      final isAuthed = authAsync.value?.isAuthenticated ?? false;
      if (isAuthed && loc == '/auth/login') {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/community',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CommunityFeedScreen(),
        routes: [
          GoRoute(
            path: 'post/:postId',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final id = state.pathParameters['postId']!;
              return CommunityPostDetailScreen(postId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const DashboardScreen(),
                routes: [
                  GoRoute(
                    path: 'plans',
                    builder: (context, state) => const PlansListScreen(),
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: 'new',
                        builder: (context, state) => const CreatePlanScreen(),
                      ),
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: ':planId',
                        builder: (context, state) {
                          final id = state.pathParameters['planId']!;
                          return PlanDetailScreen(planId: id);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: 'goals',
                    builder: (context, state) => const GoalsScreen(),
                  ),
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: 'support',
                    builder: (context, state) => const SupportHomeScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/prayer',
                builder: (context, state) => const PrayerRoomScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bible',
                builder: (context, state) => const BibleHomeScreen(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: 'read/:bookId/:chapter',
                    builder: (context, state) {
                      final book = state.pathParameters['bookId']!;
                      final ch = int.tryParse(state.pathParameters['chapter'] ?? '1') ?? 1;
                      return ChapterReaderScreen(bookId: book, chapter: ch);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/studies',
                builder: (context, state) => const StudiesHomeScreen(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: ':studyId',
                    builder: (context, state) {
                      final id = state.pathParameters['studyId']!;
                      return StudyDetailScreen(studyId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sos',
                builder: (context, state) => const SosHomeScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _SplashScreen extends ConsumerStatefulWidget {
  const _SplashScreen();

  @override
  ConsumerState<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
  }

  Future<void> _route() async {
    await ref.read(authProvider.future);
    if (!mounted) return;
    final done = await loadOnboardingCompleted();
    if (!mounted) return;
    context.go(done ? '/home' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
