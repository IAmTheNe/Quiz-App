import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/common/modules/cache.dart';
import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';
import 'package:whizz/src/features/quiz/data/repositories/quiz_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    InMemoryCache? cache,
    QuizRepository? quizRepository,
  })  : _cache = cache ?? InMemoryCache(),
        _quizRepository = quizRepository ?? QuizRepository(),
        super(const ProfileState()) {
    _onGetProfile();
  }

  final InMemoryCache _cache;
  final QuizRepository _quizRepository;

  void _onGetProfile() async {
    emit(state.copyWith(isLoading: true));
    final user = _cache.read<User>(key: 'user');
    final quiz = await _quizRepository.fetchAllQuizzes();
    emit(state.copyWith(
      user: user,
      quizzies: quiz,
      isLoading: false,
    ));
  }
}
