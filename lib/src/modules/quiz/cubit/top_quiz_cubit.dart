import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/modules/quiz/repository/quiz_repository.dart';


part 'top_quiz_state.dart';

class TopQuizCubit extends Cubit<TopQuizState> {
  TopQuizCubit({QuizRepository? repository})
      : _repository = repository ?? QuizRepository(),
        super(const TopQuizState()) {
    getTopQuiz();
  }

  final QuizRepository _repository;

  void getTopQuiz() {
    emit(state.copyWith(isLoading: true));
    _repository.fetchTopQuizzes().listen((event) {
      emit(state.copyWith(
        quiz: event,
        isLoading: false,
      ));
    });
  }
}
