// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whizz/src/features/quiz/data/extensions/extension.dart';

class Question {
  const Question({
    this.id = '',
    this.name = '',
    this.duration = 0,
    this.point = 0,
    this.type = QuestionType.choice,
    this.answers = const {},
  });

  final String? id;
  final String name;
  final int? duration;
  final int? point;
  final QuestionType type;
  final Map<String, bool> answers;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'duration': duration,
      'point': point,
      'type': type.name,
      'answers': answers,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      duration: map['duration'] != null ? map['duration'] as int : null,
      point: map['point'] != null ? map['point'] as int : null,
      type: (map['type'] as String).convertQuestionType(),
      answers: Map<String, bool>.from(
        (map['answers'] as Map<String, bool>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) => Question.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum QuestionType {
  choice,
  yesNo,
  poll,
}
