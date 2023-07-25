import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/modules/debouncer.dart';
import 'package:whizz/src/features/discovery/data/models/quiz_collection.dart';

class QuizCollectionRepository {
  QuizCollectionRepository({
    FirebaseFirestore? firestore,
    Debouncer? debouncer,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _debouncer = debouncer ?? Debouncer();

  final FirebaseFirestore _firestore;
  final Debouncer _debouncer;

  Future<List<QuizCollection>> fetchAllCollections({
    int limit = 10,
  }) async {
    final collections = <QuizCollection>[];
    await _firestore
        .collection(FirebaseDocumentConstants.collection)
        .get()
        .then((querySnapshot) {
      for (final collection in querySnapshot.docs) {
        collections.add(QuizCollection.fromMap(collection.data()));
      }
    });

    return collections;
  }

  Future<List<QuizCollection>> _searchCollection(
    String value, [
    int limit = 10,
  ]) async {
    final collections = <QuizCollection>[];
    await _firestore
        .collection(FirebaseDocumentConstants.collection)
        .get()
        .then((querySnapshot) {
      for (final collection in querySnapshot.docs) {
        final quiz = QuizCollection.fromMap(collection.data());
        if (quiz.name.toLowerCase().contains(value.toLowerCase().trim())) {
          collections.add(QuizCollection.fromMap(collection.data()));
        }
      }
    });

    return collections;
  }

  Future<List<QuizCollection>> searchCollection(
    String value, [
    int limit = 10,
  ]) async {
    return _debouncer.debounce(
      callback: _searchCollection,
      args: [value, limit],
    );
  }
}
