import 'package:flutter/material.dart';
import 'package:whizz/src/features/discovery/data/models/quiz_collection.dart';

class DiscoveryDetailScreen extends StatelessWidget {
  const DiscoveryDetailScreen({
    super.key,
    required this.quizCollection,
  });

  final QuizCollection quizCollection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quizCollection.name),
      ),
    );
  }
}