// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/modules/lobby/model/lobby.dart';
import 'package:whizz/src/modules/lobby/repository/lobby_repository.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';

part 'lobby_state.dart';

class LobbyCubit extends Cubit<Lobby> {
  LobbyCubit({LobbyRepository? repository})
      : _repository = repository ?? LobbyRepository(),
        super(const Lobby());

  final LobbyRepository _repository;

  Future<void> createLobby(
    Quiz quiz, {
    bool isSoloMode = true,
  }) async {
    const uuid = Uuid();
    final id = uuid.v4();

    emit(state.copyWith(
      id: id,
      quiz: quiz,
    ));

    final lobby = await _repository.createLobby(
      state,
      isSoloMode: isSoloMode,
    );

    _repository.lobby(lobby).listen((event) {
      emit(event);
    });

    _repository.participants(lobby).listen((event) {
      emit(state.copyWith(
        participants: event,
      ));
    });
  }

  void startGame() async {
    await _repository.startGame(state);
    emit(state.copyWith(isStart: true));
  }

  void calculateScore(int score) async {
    _repository.updateScore(state, score).then((_) => getScores());
    getScores();
  }

  void getScores() {
    Lobby lobby = state;
    lobby.participants.sort((a, b) => b.score - a.score);
    emit(lobby);
  }

  int getRank() {
    return _repository.getRank(state);
  }

  void enterRoom(BuildContext context, String code) {
    _repository.enterLobby(code).then((result) {
      if (result == null) {
        context.showErrorSnackBar('Quiz not found');
      } else {
        // _repository.lobbyInformation(result).listen((lobby) {
        //   emit(lobby);
        // });

        _repository.lobby(result).listen((event) {
          emit(event.copyWith(
            isHost: false,
          ));
        });

        _repository.participants(result).listen((event) {
          emit(state.copyWith(
            participants: event,
          ));
        });
        context.goNamed(
          RouterPath.lobby.name,
          extra: false,
        );
      }
    });
  }

  void soloHistory() async {
    final participant = await _repository.soloHistory(state);
    participant.sort((a, b) => b.score - a.score);

    emit(state.copyWith(solo: participant));
  }

  void cancel() {
    emit(const Lobby());
  }
}
