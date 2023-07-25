// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:whizz/src/features/quiz/data/models/media.dart';
import 'package:whizz/src/features/quiz/data/models/question.dart';

class Quiz extends Equatable {
  const Quiz({
    this.id = '',
    this.title = '',
    this.description = '',
    this.collectionId,
    this.visibility = QuizVisibility.public,
    this.keyword = const [],
    this.createdAt,
    this.questions = const [],
    this.media = const Media(),
    this.playedCount = 0,
    this.author = '',
  });

  final String id;
  final String title;
  final String? description;
  final String? collectionId;
  final QuizVisibility visibility;
  final List<String> keyword;
  final DateTime? createdAt;
  final Media media;
  final List<Question> questions;
  final String author;
  final int playedCount;

  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    String? collectionId,
    QuizVisibility? visibility,
    List<String>? keyword,
    DateTime? createdAt,
    List<Question>? questions,
    Media? media,
    String? author,
    int? playedCount,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      collectionId: collectionId ?? this.collectionId,
      visibility: visibility ?? this.visibility,
      keyword: keyword ?? this.keyword,
      createdAt: createdAt ?? this.createdAt,
      questions: questions ?? this.questions,
      media: media ?? this.media,
      author: author ?? this.author,
      playedCount: playedCount ?? this.playedCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        collectionId,
        visibility,
        keyword,
        createdAt,
        media,
        questions,
        author,
        playedCount,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'collectionId': collectionId,
      'isPublic': visibility.name == "public",
      'keyword': keyword,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'questions': questions.map((x) => x.toMap()).toList(),
      'imageUrl': media.imageUrl,
      'author': author,
      'played': playedCount,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'] as String,
      title: map['title'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      collectionId:
          map['collectionId'] != null ? map['collectionId'] as String : null,
      visibility: (map['isPublic'] as bool)
          ? QuizVisibility.public
          : QuizVisibility.private,
      keyword: List<String>.from((map['keyword'] as List<dynamic>)),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      questions: List<Question>.from(
        (map['questions'] as List<dynamic>).map<Question>(
          (x) => Question.fromMap(x as Map<String, dynamic>),
        ),
      ),
      playedCount: int.parse(map['played'].toString()),
      media: Media(
        imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
        type: (map['imageUrl'] as String).isEmpty
            ? AttachType.none
            : AttachType.online,
      ),
      author: map['author'],
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
