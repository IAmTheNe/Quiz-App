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
import 'package:whizz/src/modules/quiz/repository/quiz_repository.dart';
import 'package:whizz/src/router/app_router.dart';

part 'lobby_state.dart';

class LobbyCubit extends Cubit<Lobby> {
  LobbyCubit({
    LobbyRepository? lobbyRepository,
    QuizRepository? quizRepository,
  })  : _lobbyRepository = lobbyRepository ?? LobbyRepository(),
        _quizRepository = quizRepository ?? QuizRepository(),
        super(const Lobby());

  final LobbyRepository _lobbyRepository;
  final QuizRepository _quizRepository;

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

    final lobby = await _lobbyRepository.createLobby(
      state,
      isSoloMode: isSoloMode,
    );

    _lobbyRepository.lobby(lobby).listen((event) {
      emit(event);
    });

    _lobbyRepository.participants(lobby).listen((event) {
      emit(state.copyWith(
        participants: event,
      ));
    });
  }

  void startGame() async {
    // await _quizRepository.updateNumOfPlayer(state.quiz);
    // await _lobbyRepository.startGame(state);
    await Future.wait([
      _quizRepository.updateNumOfPlayer(state.quiz),
      _lobbyRepository.startGame(state),
    ]);
  }

  void calculateScore(int score) async {
    _lobbyRepository.updateScore(state, score).then((_) => getScores());
    // getScores();
  }

  void getScores() {
    final participants = state.participants;
    participants.sort((a, b) => b.score! - a.score!);
    emit(state.copyWith(
      participants: participants,
    ));
  }

  int getRank() {
    return _lobbyRepository.getRank(state);
  }

  void enterRoom(BuildContext context, String code) {
    _lobbyRepository.enterLobby(code).then((result) {
      if (result == null) {
        context.showErrorSnackBar('Quiz not found');
      } else {
        // _repository.lobbyInformation(result).listen((lobby) {
        //   emit(lobby);
        // });

        _lobbyRepository.lobby(result).listen((event) {
          emit(event.copyWith(
            isHost: false,
          ));
        });

        _lobbyRepository.participants(result).listen((event) {
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
    final participant = await _lobbyRepository.soloHistory(state);
    participant.sort((a, b) => b.score! - a.score!);

    emit(state.copyWith(solo: participant));
  }

  Future<void> rating(bool isClicked, double rating) async {
    if (isClicked) {
      await _quizRepository.rating(state.quiz, rating);
    }
  }

  void cancel() {
    emit(const Lobby());
  }
}
