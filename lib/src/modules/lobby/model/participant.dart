// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whizz/src/modules/auth/models/user.dart';

class Participant {
  const Participant({
    required this.participant,
    required this.score,
  });

  final AppUser participant;
  final int score;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'participant': participant.toMap(),
      'score': score,
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      participant: AppUser.fromMap(map['participant'] as Map<String, dynamic>),
      score: map['score'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Participant.fromJson(String source) =>
      Participant.fromMap(json.decode(source) as Map<String, dynamic>);
}
