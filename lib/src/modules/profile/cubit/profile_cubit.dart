import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/common/utils/cache.dart';
import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/modules/quiz/repository/quiz_repository.dart';

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
  }
}
