import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/common/utils/cache.dart';
import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/modules/auth/repository/auth_repository.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/modules/quiz/repository/quiz_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    InMemoryCache? cache,
    QuizRepository? quizRepository,
    AuthenticationRepository? authenticationRepository,
  })  : _cache = cache ?? InMemoryCache(),
        _quizRepository = quizRepository ?? QuizRepository(),
        _authenticationRepository =
            authenticationRepository ?? AuthenticationRepository(),
        super(const ProfileState()) {
    _onGetProfile();
  }

  final InMemoryCache _cache;
  final QuizRepository _quizRepository;
  final AuthenticationRepository _authenticationRepository;

  void _onGetProfile() async {
    emit(state.copyWith(isLoading: true));
    final user = _cache.read<AppUser>(key: 'user');
    _quizRepository.fetchAllQuizzes2().listen(
      (quiz) {
        emit(
          state.copyWith(
            user: user,
            quizzies: quiz,
            isLoading: false,
          ),
        );
      },
    );
    _quizRepository.fetchBookmarks().listen((bm) async {
      final newData = <Quiz>[];
      for (final quiz in bm) {
        final data = await _quizRepository.getQuizById(quiz);
        newData.add(data);
      }

      emit(state.copyWith(
        save: newData,
        isLoading: false,
      ));
    });
  }

  Future<void> onEditProfile(String displayName, File? avatar) async {
    emit(state.copyWith(isLoading: true));
    await _authenticationRepository.updateUser(displayName, avatar);
    final user = _cache.read<AppUser>(key: 'user');
    emit(state.copyWith(
      isLoading: false,
      user: user,
    ));
  }

  Future<void> onSaveQuiz(Quiz quiz) async {
    emit(state.copyWith(isLoading: true));
    await _quizRepository.saveQuiz(quiz);
    emit(state.copyWith(isLoading: false));
  }
}
