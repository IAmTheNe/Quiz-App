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

  Future<Lobby> createLobby(Lobby lobby) async {
    final user = _cache.read<AppUser>(key: 'user');
    final participant = Participant(participant: user!, score: 0);
    final participants = List<Participant>.from(lobby.participants)
      ..add(participant);
    final lobbyNew = lobby.copyWith(
      host: user,
      participants: participants,
    );
    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .set(lobbyNew.toMap());

    return lobbyNew;
  }

  enterLobby() {}

  Stream<Lobby> lobbyScore(Lobby lobby) {
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
}
