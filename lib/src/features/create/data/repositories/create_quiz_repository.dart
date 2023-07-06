import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/features/create/data/models/quiz.dart';
import 'package:whizz/src/modules/cache.dart';

class CreateQuizRepository {
  CreateQuizRepository({
    CacheClient? cache,
    FirebaseFirestore? firestore,
  })  : _cache = cache ?? CacheClient(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final CacheClient _cache;
  final FirebaseFirestore _firestore;

  Future<void> createNewQuiz(Quiz quiz) async {
    final uuid = Uuid();
    final quizId = uuid.v4();
    final createdAt = DateTime.now();

    print(quizId);
    final newQuiz = quiz.copyWith(
      id: quizId,
      createdAt: createdAt,
    );

    print(newQuiz.toMap());
    await _firestore
        .collection(FirebaseDocumentConstants.user)
        .doc(_cache.read<User>(key: 'user')!.id)
        .collection(FirebaseDocumentConstants.quiz)
        .doc(quizId)
        .set(newQuiz.toMap());
  }
}
