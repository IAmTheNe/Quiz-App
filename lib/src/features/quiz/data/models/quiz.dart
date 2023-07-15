// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:whizz/src/features/quiz/data/extensions/extension.dart';
import 'package:whizz/src/features/quiz/data/models/question.dart';

class Quiz extends Equatable {
  const Quiz({
    this.id,
    this.title = '',
    this.description = '',
    this.collectionId,
    this.imageUrl,
    this.visibility = QuizVisibility.public,
    this.keyword = const [],
    this.createdAt,
    this.attachType = AttachType.none,
    this.questions = const [],
  });

  final String? id;
  final String? title;
  final String? description;
  final String? collectionId;
  final String? imageUrl;
  final QuizVisibility visibility;
  final List<String>? keyword;
  final DateTime? createdAt;
  final AttachType attachType;
  final List<Question> questions;

  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    String? collectionId,
    String? imageUrl,
    QuizVisibility? visibility,
    List<String>? keyword,
    DateTime? createdAt,
    AttachType? attachType,
    List<Question>? questions,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      collectionId: collectionId ?? this.collectionId,
      imageUrl: imageUrl ?? this.imageUrl,
      visibility: visibility ?? this.visibility,
      keyword: keyword ?? this.keyword,
      createdAt: createdAt ?? this.createdAt,
      attachType: attachType ?? this.attachType,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        collectionId,
        imageUrl,
        visibility,
        keyword,
        createdAt,
        attachType,
        questions,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'collectionId': collectionId,
      'imageUrl': imageUrl,
      'visibility': visibility.name,
      'keyword': keyword,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'attachType': attachType.name,
      'questions': questions.map((x) => x.toMap()).toList(),
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      collectionId:
          map['collectionId'] != null ? map['collectionId'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      visibility: (map['visibility'] as String).convertQuizVisibitity(),
      keyword: map['keyword'] != null
          ? List<String>.from((map['keyword'] as List<String>))
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      attachType: (map['attachType'] as String).convertAttachType(),
      questions: List<Question>.from(
        (map['questions'] as List<int>).map<Question>(
          (x) => Question.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Quiz.fromJson(String source) =>
      Quiz.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum QuizVisibility {
  public,
  private,
}

enum AttachType {
  none,
  local,
  online,
}
