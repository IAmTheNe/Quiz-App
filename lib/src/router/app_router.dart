import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/features/auth/data/bloc/auth_cubit.dart';
import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';
import 'package:whizz/src/features/auth/ui/auth_screen.dart';
import 'package:whizz/src/features/home/ui/home_screen.dart';

enum RouterPath {
  home,
  login,
  register,
  noConnection,
  error,
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _authRepo = AuthenticationRepository();

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/auth',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final isLoggedIn = _authRepo.currentUser != User.empty;
      if (isLoggedIn) {
        if (state.matchedLocation == '/auth') {
          return '/home';
        }
      } else {
        if (state.matchedLocation == '/home') {
          return '/auth';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(_authRepo.user),
    routes: [
      GoRoute(
        path: '/auth',
        name: RouterPath.login.name,
        builder: (context, state) => BlocProvider(
          create: (_) => AuthCubit(_authRepo),
          child: const AuthScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        name: RouterPath.home.name,
        pageBuilder: (context, state) => MaterialPage(
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
