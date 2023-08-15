import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

class Lobby {
  const Lobby({
    this.id = '',
    this.participants = const [],
    this.quiz = const Quiz(),
    this.host = AppUser.empty,
  });

  final String id;
  final List<AppUser> participants;
  final Quiz quiz;
  final AppUser host;
}
