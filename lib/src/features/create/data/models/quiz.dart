// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:whizz/src/features/create/data/extensions/extension.dart';

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
    this.attachType = AttachType.local,
  });

  factory Quiz.fromQuiz(Quiz quiz) {
    return Quiz(
      id: quiz.id,
      title: quiz.title,
      description: quiz.description,
      collectionId: quiz.collectionId,
      imageUrl: quiz.imageUrl,
      visibility: quiz.visibility,
      keyword: quiz.keyword,
      createdAt: quiz.createdAt,
      attachType: quiz.attachType,
    );
  }

  final String? id;
  final String? title;
  final String? description;
  final String? collectionId;
  final String? imageUrl;
  final QuizVisibility visibility;
  final List<String>? keyword;
  final DateTime? createdAt;
  final AttachType attachType;

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
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      if (collectionId != null) 'collectionId': collectionId,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'visibility': visibility.name,
      if (keyword != null) 'keyword': keyword,
      'createdAt': createdAt?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
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
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      visibility: (map['visibility'] as String).toEnum(),
      keyword: map['keyword'] != null
          ? List<String>.from((map['keyword'] as List<String>))
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
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
  local,
  online,
}
