// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class QuizCollection extends Equatable {
  const QuizCollection({
    required this.id,
    required this.name,
    this.imageUrl,
    this.quantity = 0,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final int quantity;

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        quantity,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }

  factory QuizCollection.fromMap(Map<String, dynamic> map) {
    return QuizCollection(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      quantity: int.parse(map['quantity'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizCollection.fromJson(String source) =>
      QuizCollection.fromMap(json.decode(source) as Map<String, dynamic>);
}
