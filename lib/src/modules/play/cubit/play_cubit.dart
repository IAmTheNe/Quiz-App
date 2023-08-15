import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/modules/quiz/model/question.dart';

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

  void nextQuestion(int index) {
    emit(state.copyWith(
      currentQuestion: index + 1,
      // remainTime: quiz.questions[state.currentQuestion].duration ?? 0,
      answers: List.from(state.answers)..insert(index + 1, null),
    ));
  }

  void chooseAnswer(int index) {
    final answerChanged = List<int?>.from(state.answers);
    answerChanged[state.currentQuestion] = index;

    emit(state.copyWith(answers: answerChanged));
  }

  void tick(int t) {
    emit(state.copyWith(
      remainTime: t,
    ));
  }

  void calculateScore(Question q, bool isCorrect) {
    final previousScore = state.score;
    int score = 0;
    final time = q.duration! - state.remainTime;
    final percent = state.remainTime / q.duration!;

    if (isCorrect) {
      if (percent >= 0.8) {
        score = 1000;
      } else if (percent >= 0.6) {
        score = 980 - time * 2;
      } else if (percent >= 0.3) {
        score = 960 - time * 2;
      } else {
        score = 940 - time * 3;
      }
    }

    emit(
      state.copyWith(score: previousScore + score),
    );
  }
}
