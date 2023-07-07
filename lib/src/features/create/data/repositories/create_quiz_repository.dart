import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/modules/cache.dart';
import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/features/create/data/models/quiz.dart';

class CreateQuizRepository {
  CreateQuizRepository({
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
    final quizId = uuid.v4();
    final createdAt = DateTime.now();

    String url = quiz.imageUrl!;

    if (quiz.attachType == AttachType.local) {
      final file = File(quiz.imageUrl!);
      url = await getDownloadUrl(path: 'quiz/$quizId', file: file);
    }

    final newQuiz = quiz.copyWith(
      id: quizId,
      createdAt: createdAt,
      imageUrl: url,
    );

    await _firestore
        .collection(FirebaseDocumentConstants.user)
        .doc(_cache.read<User>(key: 'user')!.id)
        .collection(FirebaseDocumentConstants.quiz)
        .doc(quizId)
        .set(newQuiz.toMap());
  }

  Future<String> getDownloadUrl({
    required String path,
    required File file,
  }) async {
    final uploadTask = _storage.ref().child(path).putFile(file);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
