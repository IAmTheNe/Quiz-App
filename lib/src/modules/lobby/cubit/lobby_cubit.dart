import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:whizz/src/modules/lobby/model/lobby.dart';
import 'package:whizz/src/modules/lobby/repository/lobby_repository.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

part 'lobby_state.dart';

class LobbyCubit extends Cubit<Lobby> {
  LobbyCubit({LobbyRepository? repository})
      : _repository = repository ?? LobbyRepository(),
        super(const Lobby());

  final LobbyRepository _repository;

  Future<void> createLobby(Quiz quiz) async {
    const uuid = Uuid();
    final id = uuid.v4();

    emit(state.copyWith(
      id: id,
      quiz: quiz,
    ));

    final lobby = await _repository.createLobby(state);
    emit(state.copyWith(
      host: lobby.host,
      participants: lobby.participants,
    ));
  }

  void calculateScore(int score) async {
    await _repository.calculateScore(state, score);
    getScores();
  }

  void getScores() {
    _repository.lobbyScore(state).listen((lobby) {
      lobby.participants.sort((a, b) => a.score - b.score);
      emit(lobby);
    });
  }

  int getRank() {
    return _repository.getRank(state);
  }

  void cancel() {
    emit(const Lobby());
  }
}
