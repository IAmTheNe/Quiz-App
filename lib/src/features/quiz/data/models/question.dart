// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:whizz/src/features/quiz/data/extensions/extension.dart';
import 'package:whizz/src/features/quiz/data/models/answer.dart';

class Question extends Equatable {
  const Question({
    this.id = '',
    this.name = '',
    this.duration = 0,
    this.point = 0,
    this.type = QuestionType.choice,
    this.answers = const [],
  });

  final String? id;
  final String name;
  final int? duration;
  final int? point;
  final QuestionType type;
  final List<Answer> answers;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'duration': duration,
      'point': point,
      'type': type.name,
      'answers': answers.map((x) => x.toMap()).toList(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      duration: map['duration'] != null ? map['duration'] as int : null,
      point: map['point'] != null ? map['point'] as int : null,
      type: (map['type'] as String).convertQuestionType(),
      answers: List<Answer>.from(
        (map['answers'] as List<dynamic>).map<Answer>(
          (x) => Answer.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        id,
        name,
        duration,
        point,
        type,
        answers,
      ];

  Question copyWith({
    String? id,
    String? name,
    int? duration,
    int? point,
    QuestionType? type,
    List<Answer>? answers,
  }) {
    return Question(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      point: point ?? this.point,
      type: type ?? this.type,
      answers: answers ?? this.answers,
    );
  }
}

enum QuestionType {
  choice,
  yesNo,
  poll,
}
