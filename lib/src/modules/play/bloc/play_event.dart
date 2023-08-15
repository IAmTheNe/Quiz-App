part of 'play_bloc.dart';

sealed class GameEvent {
  const GameEvent();
}

class GameEnterEvent implements GameEvent {
  const GameEnterEvent(this.context, this.quiz);

  final BuildContext context;
  final Quiz quiz;
}

class GameRunningEvent implements GameEvent {
  const GameRunningEvent();
}

class GameShowAnswer implements GameEvent {
  const GameShowAnswer();
}

class GameShowLeaderboard implements GameEvent {
  const GameShowLeaderboard();
}

class StartTeamGame implements GameEvent {}

class StartTimer implements GameEvent {
  const StartTimer([this.duration = 0]);

  final int duration;
}


// Game Enter => Game Counting => Game End (show Correct Answer) => Game show leaderboard => Game Start