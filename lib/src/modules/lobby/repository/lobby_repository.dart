import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/utils/cache.dart';
import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/modules/lobby/model/lobby.dart';
import 'package:whizz/src/modules/lobby/model/participant.dart';

class LobbyRepository {
  LobbyRepository({
    FirebaseFirestore? firestore,
    InMemoryCache? cache,
  })  : _cache = cache ?? InMemoryCache(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final InMemoryCache _cache;

  Future<Lobby> createLobby(
    Lobby lobby, {
    bool isSoloMode = true,
  }) async {
    final user = _cache.read<AppUser>(key: 'user');
    final now = DateTime.now();
    final participant = Participant(participant: user!, score: 0);
    final participants = List<Participant>.from(lobby.participants)
      ..add(participant);

    final lobbyNew = lobby.copyWith(
      host: user,
      participants: participants,
      startTime: now,
      code: isSoloMode ? null : _randomCode(),
    );

    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .set(lobbyNew.toMap());

    return lobbyNew;
  }

  Future<void> startGame(Lobby lobby) async {
    final lobbyNew = lobby.copyWith(
      isStart: true,
    );
    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .set(lobbyNew.toMap());
  }

  String _randomCode() {
    final rand = Random().nextInt(1000000);
    return rand.toString().padLeft(6, '0');
  }

  Future<Lobby?> enterLobby(String code) async {
    final lobbies = <Lobby>[];
    final user = _cache.read<AppUser>(key: 'user');
    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .where('code', isEqualTo: code)
        .where('isStart', isEqualTo: false)
        .get()
        .then((querySnapshot) {
      for (final lobby in querySnapshot.docs) {
        lobbies.add(Lobby.fromMap(lobby.data()));
      }
    });

    if (lobbies.isEmpty) {
      return null;
    }

    final participants = List<Participant>.from(lobbies[0].participants)
      ..add(Participant(participant: user!, score: 0));

    final lobby = lobbies[0].copyWith(participants: participants);
    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .set(lobby.toMap());

    return lobby;
  }

  Stream<Lobby> lobbyInformation(Lobby lobby) {
    return _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .where('id', isEqualTo: lobby.id)
        .snapshots()
        .asyncMap((event) {
      return Lobby.fromMap(event.docs[0].data());
    });
  }

  Future<void> calculateScore(Lobby lobby, int score) async {
    final user = _cache.read<AppUser>(key: 'user');
    final participant = Participant(
      participant: user!,
      score: score,
    );
    final index = lobby.participants.indexWhere(
      (e) => user.id == e.participant.id,
    );

    lobby.participants[index] = participant;
    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .set(lobby.toMap());
  }

  int getRank(Lobby lobby) {
    final user = _cache.read<AppUser>(key: 'user');
    final index = lobby.participants.indexWhere(
      (e) => user!.id == e.participant.id,
    );

    return index;
  }

  Future<List<Participant>> soloHistory(Lobby lobby) async {
    final listLobby = <Lobby>[];
    final participant = <Participant>[];

    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .where('quiz', isEqualTo: lobby.quiz.toMap())
        .where('isSolo', isEqualTo: true)
        .get()
        .then((querySnapshot) {
      for (final doc in querySnapshot.docs) {
        listLobby.add(Lobby.fromMap(doc.data()));
      }

      for (final lobby in listLobby) {
        participant.add(lobby.participants[0]);
      }
    });

    return participant;
  }
}
