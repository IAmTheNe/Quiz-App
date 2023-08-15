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
}
