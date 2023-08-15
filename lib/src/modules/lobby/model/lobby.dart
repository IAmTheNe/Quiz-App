// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/modules/lobby/model/participant.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

class Lobby {
  const Lobby({
    this.id = '',
    this.participants = const [],
    this.quiz = const Quiz(),
    this.host = AppUser.empty,
  });

  final String id;
  final List<Participant> participants;
  final Quiz quiz;
  final AppUser host;

  Lobby copyWith({
    String? id,
    List<Participant>? participants,
    Quiz? quiz,
    AppUser? host,
  }) {
    return Lobby(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      quiz: quiz ?? this.quiz,
      host: host ?? this.host,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'participants': participants.map((x) => x.toMap()).toList(),
      'quiz': quiz.toMap(),
      'host': host.toMap(),
    };
  }

  factory Lobby.fromMap(Map<String, dynamic> map) {
    return Lobby(
      id: map['id'] as String,
      participants: List<Participant>.from((map['participants'] as List<int>).map<Participant>((x) => Participant.fromMap(x as Map<String,dynamic>),),),
      quiz: Quiz.fromMap(map['quiz'] as Map<String,dynamic>),
      host: AppUser.fromMap(map['host'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Lobby.fromJson(String source) => Lobby.fromMap(json.decode(source) as Map<String, dynamic>);
}
