import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

part 'play_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState()) {
    enterGame();
  }

  void enterGame() {
    emit(
      state.copyWith(
        answers: List.from(state.answers)..insert(0, null),
      ),
    );
  }

  void nextQuestion(Quiz quiz) {
    emit(state.copyWith(
      currentQuestion: state.currentQuestion + 1,
      remainTime: quiz.questions[state.currentQuestion].duration ?? 0,
      answers: List.from(state.answers)..add(null),
    ));
  }

  void chooseAnswer(int index) {
    final answerChanged = List<int?>.from(state.answers);
    answerChanged[state.currentQuestion] = index;

    emit(state.copyWith(answers: answerChanged));
  }
}
