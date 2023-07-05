import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';
import 'package:whizz/src/features/auth/ui/login_screen.dart';
import 'package:whizz/src/features/auth/ui/otp_screen.dart';
import 'package:whizz/src/features/create/ui/create_quiz_screen.dart';
import 'package:whizz/src/features/discovery/ui/discovery_screen.dart';
import 'package:whizz/src/features/home/ui/home_screen.dart';
import 'package:whizz/src/features/play/ui/play_screen.dart';
import 'package:whizz/src/features/profile/ui/profile_screen.dart';
import 'package:whizz/src/router/scaffold_with_bottom_nav_bar.dart';

enum RouterPath {
  home,
  login,
  otp,
  discovery,
  play,
  create,
  profile,
  noConnection,
  error,
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final _authRepo = AuthenticationRepository();

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/login',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final isLoggedIn = _authRepo.currentUser != User.empty;
      if (isLoggedIn) {
        if (state.matchedLocation == '/login') {
          return '/home';
        }
      } else {
        if (state.matchedLocation == '/home') {
          return '/login';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(_authRepo.user),
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: RouterPath.home.name,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/discovery',
            name: RouterPath.discovery.name,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DiscoveryScreen(),
            ),
          ),
          GoRoute(
            path: '/play',
            name: RouterPath.play.name,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const PlayScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: RouterPath.profile.name,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/create',
        name: RouterPath.create.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: const CreateQuizScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: RouterPath.login.name,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/otp',
        name: RouterPath.otp.name,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: OtpScreen(
            codeSent: state.extra as (String, int),
          ),
        ),
      ),
    ],
  );

  static GoRouter get router => _router;
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
