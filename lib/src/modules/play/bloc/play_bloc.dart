import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/utils/timer.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';

part 'play_event.dart';
part 'play_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState()) {
    on(_onEnterGame);
    on(_onGameRunning);
    on(_onGameShowAnswer);
  }

  void _onEnterGame(
    GameEnterEvent event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(
        quiz: event.quiz,
        remainTime: event.quiz.questions[state.currentQuestion].duration ?? 0));

    final context = event.context;
    context.goNamed(
      RouterPath.playQuiz.name,
      pathParameters: {'id': event.quiz.id},
      extra: context.read<GameBloc>(),
    );
  }

  void _onGameRunning(
    GameRunningEvent event,
    Emitter<GameState> emit,
  ) async {
    final duration = state.quiz.questions[state.currentQuestion].duration ?? 0;

    Ticker.tick(ticks: duration).listen((event) {
      emit(state.copyWith(remainTime: event));
    });
  }

  void _onGameShowAnswer(
    GameShowAnswer event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(currentQuestion: state.currentQuestion + 1));
  }
}
