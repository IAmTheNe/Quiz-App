// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'play_bloc.dart';

class GameState extends Equatable {
  const GameState({
    this.quiz = const Quiz(),
    this.answers = const [],
    this.currentQuestion = 0,
    this.remainTime = 0,
  });

  final Quiz quiz;
  final List<int> answers;
  final int currentQuestion;
  final int remainTime;

  GameState copyWith({
    Quiz? quiz,
    List<int>? answers,
    int? currentQuestion,
    int? remainTime,
  }) {
    return GameState(
      quiz: quiz ?? this.quiz,
      answers: answers ?? this.answers,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      remainTime: remainTime ?? this.remainTime,
    );
  }

  @override
  List<Object?> get props => [
        quiz,
        answers,
        currentQuestion,
        remainTime,
      ];
}

// class GameStarted implements GameState {
//   const GameStarted();
// }

// class GameContinued implements GameState {
//   const GameContinued(this.duration);

//   final int duration;
// }

// class GameEnded implements GameState {
//   const GameEnded();
// }

// class GameResutl implements GameState {
//   const GameResutl();
// }

// class GameNextQuestion implements GameState {
//   const GameNextQuestion();
// }

// Enter game => Next Question => Result
