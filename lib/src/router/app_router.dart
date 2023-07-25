import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';
import 'package:whizz/src/features/auth/presentation/login_screen.dart';
import 'package:whizz/src/features/auth/presentation/otp_screen.dart';
import 'package:whizz/src/features/discovery/data/models/quiz_collection.dart';
import 'package:whizz/src/features/discovery/presentation/screens/discovery_detail_screen.dart';
import 'package:whizz/src/features/discovery/presentation/screens/discovery_screen.dart';
import 'package:whizz/src/features/home/data/cubit/top_quiz_cubit.dart';
import 'package:whizz/src/features/home/presentation/screens/home_screen.dart';
import 'package:whizz/src/features/media/presentation/screens/media_screen.dart';
import 'package:whizz/src/features/play/presentation/screens/play_screen.dart';
import 'package:whizz/src/features/profile/data/bloc/profile_cubit.dart';
import 'package:whizz/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:whizz/src/features/quiz/data/bloc/quiz_bloc.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';
import 'package:whizz/src/features/quiz/presentation/screens/create_question_screen.dart';
import 'package:whizz/src/features/quiz/presentation/screens/create_quiz_screen.dart';
import 'package:whizz/src/features/quiz/presentation/screens/edit_quiz_screen.dart';
import 'package:whizz/src/features/quiz/presentation/screens/question_detail_screen.dart';
import 'package:whizz/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:whizz/src/router/scaffold_with_bottom_nav_bar.dart';

enum RouterPath {
  home,
  login,
  otp,
  discovery,
  discoveryDetail,
  play,
  quiz,
  quizDetail,
  quizEdit,
  question,
  media,
  unsplash,
  settings,
  noConnection,
  error,
  profile,
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
              child: BlocProvider(
                create: (_) => TopQuizCubit(),
                child: const HomeScreen(),
              ),
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
        path: '/play',
        name: RouterPath.play.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => NoTransitionPage(
          key: state.pageKey,
          child: const PlayScreen(),
        ),
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
                create: (_) => QuizBloc(),
              ),
            ],
            child: const CreateQuizScreen(),
          ),
        ),
        routes: [
          GoRoute(
            path: ':id',
            name: RouterPath.quizDetail.name,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: QuestionDetailScreen(
                quiz: state.extra! as Quiz,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/quiz_edit',
        name: RouterPath.quizEdit.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider.value(
            value: state.extra! as QuizBloc,
            child: const EditQuizScreen(),
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
            value: state.extra! as QuizBloc,
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
          child: const MediaScreen(),
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
      GoRoute(
        path: '/profile',
        name: RouterPath.profile.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ProfileCubit()),
              BlocProvider(create: (_) => QuizBloc()),
            ],
            child: const ProfileScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '/discovery_detail',
        name: RouterPath.discoveryDetail.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: DiscoveryDetailScreen(
            quizCollection: state.extra! as QuizCollection,
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
