import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';
import 'package:whizz/src/features/auth/ui/login_screen.dart';
import 'package:whizz/src/features/auth/ui/otp_screen.dart';
import 'package:whizz/src/features/home/ui/home_screen.dart';

enum RouterPath {
  home,
  login,
  otp,
  noConnection,
  error,
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

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
      GoRoute(
        path: '/home',
        name: RouterPath.home.name,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: const HomeScreen(),
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
