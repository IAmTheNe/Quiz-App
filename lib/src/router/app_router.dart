import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';
import 'package:whizz/src/features/auth/presentation/login_screen.dart';
import 'package:whizz/src/features/auth/presentation/otp_screen.dart';
import 'package:whizz/src/features/discovery/presentation/discovery_screen.dart';
import 'package:whizz/src/features/home/presentation/screens/home_screen.dart';
import 'package:whizz/src/features/media/data/bloc/online_media_bloc.dart';
import 'package:whizz/src/features/media/presentation/screens/media_screen.dart';
import 'package:whizz/src/features/play/presentation/play_screen.dart';
import 'package:whizz/src/features/quiz/data/bloc/create_quiz_cubit.dart';
import 'package:whizz/src/features/quiz/presentation/screens/create_question_screen.dart';
import 'package:whizz/src/features/quiz/presentation/screens/create_quiz_screen.dart';
import 'package:whizz/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:whizz/src/router/scaffold_with_bottom_nav_bar.dart';

enum RouterPath {
  home,
  login,
  otp,
  discovery,
  play,
  quiz,
  question,
  media,
  unsplash,
  settings,
  noConnection,
  error,
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final _authRepo = AuthenticationRepository();

  static final _quizCubit = CreateQuizCubit();

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
        if (state.matchedLocation == '/home' ||
            state.matchedLocation == '/settings') {
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
            path: '/settings',
            name: RouterPath.settings.name,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/quiz',
        name: RouterPath.quiz.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) =>
                      OnlineMediaBloc()..add(const GetListPhotosEvent())),
              BlocProvider.value(value: _quizCubit),
            ],
            child: const CreateQuizScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '/question',
        name: RouterPath.question.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider.value(
            value: _quizCubit,
            child: const CreateQuestionScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '/media',
        name: RouterPath.media.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => OnlineMediaBloc()..add(const GetListPhotosEvent()),
            child: const MediaScreen(),
          ),
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
