import 'package:whizz/src/features/quiz/data/models/quiz.dart';

class Media {
  const Media({
    this.imageUrl,
    this.type = AttachType.none,
  });

  final String? imageUrl;
  final AttachType type;
}
