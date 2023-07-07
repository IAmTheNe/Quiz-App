import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/features/create/data/models/quiz.dart';
import 'package:whizz/src/common/modules/cache.dart';

class CreateQuizRepository {
  CreateQuizRepository({
    InMemoryCache? cache,
    FirebaseFirestore? firestore,
  })  : _cache = cache ?? InMemoryCache(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final InMemoryCache _cache;
  final FirebaseFirestore _firestore;

  Future<void> createNewQuiz(Quiz quiz) async {
    const uuid = Uuid();
    final quizId = uuid.v4();
    final createdAt = DateTime.now();

    final newQuiz = quiz.copyWith(
      id: quizId,
      createdAt: createdAt,
    );

    await _firestore
        .collection(FirebaseDocumentConstants.user)
        .doc(_cache.read<User>(key: 'user')!.id)
        .collection(FirebaseDocumentConstants.quiz)
        .doc(quizId)
        .set(newQuiz.toMap());
  }
}
