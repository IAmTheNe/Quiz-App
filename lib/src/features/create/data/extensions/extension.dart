import 'package:whizz/src/features/create/data/models/quiz.dart';

extension EnumX on String {
  QuizVisibility toEnum() {
    switch (this) {
      case 'private':
        return QuizVisibility.private;
      case 'public':
        return QuizVisibility.public;
      default:
        return QuizVisibility.public;
    }
  }
}
