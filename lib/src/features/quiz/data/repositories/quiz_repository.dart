import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/utils/cache.dart';
import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/features/quiz/data/models/media.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';

class QuizRepository {
  QuizRepository({
    InMemoryCache? cache,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _cache = cache ?? InMemoryCache(),
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final InMemoryCache _cache;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Future<void> createNewQuiz(Quiz quiz) async {
    const uuid = Uuid();
    final user = _cache.read<User>(key: 'user');
    final quizId = quiz.id.isNotEmpty ? quiz.id : uuid.v4();
    final createdAt = DateTime.now();

    String quizImageUrl = await _getDownloadUrl(
      path: 'quiz/$quizId/cover.jpg',
      media: quiz.media,
    );

    final updatedQuestionList = await Future.wait(
      quiz.questions.map(
        (question) => _getDownloadUrl(
          path: 'quiz/$quizId/${question.id}/',
          media: question.media,
        ).then(
          (imageUrl) => question.copyWith(
            media: question.media.copyWith(imageUrl: imageUrl),
          ),
        ),
      ),
    );

    final newQuiz = quiz.copyWith(
      id: quizId,
      createdAt: createdAt,
      media: Media(
        imageUrl: quizImageUrl,
      ),
      questions: updatedQuestionList,
      author: user!.id,
    );

    await _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .doc(quizId)
        .set(newQuiz.toMap());
  }

  Future<List<Quiz>> fetchAllQuizzes() async {
    final quiz = <Quiz>[];
    await _firestore
        .collection(FirebaseDocumentConstants.user)
        .doc(_cache.read<User>(key: 'user')!.id)
        .collection(FirebaseDocumentConstants.quiz)
        .get()
        .then((querySnapshot) {
      for (final quizzes in querySnapshot.docs) {
        quiz.add(Quiz.fromMap(quizzes.data()));
      }
    });

    return quiz;
  }

  Stream<List<Quiz>> fetchAllQuizzes2() {
    final userId = _cache.read<User>(key: 'user')!.id;
    return _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .where('author', isEqualTo: userId)
        .snapshots()
        .asyncMap((event) {
      final quiz = <Quiz>[];
      for (final doc in event.docs) {
        quiz.add(Quiz.fromMap(doc.data()));
      }

      return quiz;
    });
  }

  Stream<List<Quiz>> fetchTopQuizzes() {
    return _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .where('isPublic', isEqualTo: true)
        .orderBy('played', descending: true)
        .snapshots()
        .asyncMap((event) {
      final quiz = <Quiz>[];
      for (final doc in event.docs) {
        quiz.add(Quiz.fromMap(doc.data()));
      }

      return quiz;
    });
  }

  Future<String> _getDownloadUrl({
    required String path,
    required Media media,
  }) async {
    if (media.type == AttachType.online) return media.imageUrl!;
    if (media.type == AttachType.none) return '';

    final file = File(media.imageUrl!);
    final uploadTask = _storage.ref().child(path).putFile(file);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
